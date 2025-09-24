public class ParentTeamPointsRollupHandler {
    public static void rollupParentTeamPoints(List<Team__c> teams) {
        Set<Id> parentTeamIds = new Set<Id>();

        // Collect Parent Teams to update (Offices or Countries)
        for(Team__c t : teams) {
            if(t.Parent_Team__c != null) {
                parentTeamIds.add(t.Parent_Team__c);
            }
        }
        if(parentTeamIds.isEmpty()) return;

        // Fetch parents with their types
        Map<Id, Team__c> parentTeams = new Map<Id, Team__c>(
            [SELECT Id, Type__c FROM Team__c WHERE Id IN :parentTeamIds]
        );

        Map<Id, Decimal> parentPointsMap = new Map<Id, Decimal>();

        // For each parent team, sum child points based on parent's Type
        for(Id parentId : parentTeamIds) {
            Team__c parent = parentTeams.get(parentId);
            if(parent == null) continue;

            // Decide child type based on parent's type
            String childType = '';
            if(parent.Type__c == 'Office') {
                childType = 'Team';
            } else if(parent.Type__c == 'Country') {
                childType = 'Office';
            } else {
                // For Teams of type 'Team' or unknown, no further rollup
                continue;
            }

            // Sum child points
            AggregateResult[] childPointsAgg = [
                SELECT SUM(Total_Points__c) totalPoints
                FROM Team__c
                WHERE Parent_Team__c = :parentId
                AND Type__c = :childType
            ];

            Decimal totalPoints = (childPointsAgg.size() > 0) ? (Decimal)childPointsAgg[0].get('totalPoints') : 0;
            if(totalPoints == null) totalPoints = 0;

            parentPointsMap.put(parentId, totalPoints);
        }

        List<Team__c> parentsToUpdate = new List<Team__c>();
        for(Id pid : parentPointsMap.keySet()) {
            parentsToUpdate.add(new Team__c(Id=pid, Total_Points__c=parentPointsMap.get(pid)));
        }

        if(!parentsToUpdate.isEmpty()) {
            update parentsToUpdate;
        }
    }
}
