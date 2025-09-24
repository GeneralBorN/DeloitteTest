public class TeamPointsRollupHandler {
    public static void rollupTeamPoints(List<Employee__c> employees) {
        Set<Id> teamIds = new Set<Id>();
        for(Employee__c emp : employees) {
            if(emp.Reference_to_Team__c != null) {
                teamIds.add(emp.Reference_to_Team__c);
            }
        }
        if(teamIds.isEmpty()) return;

        // Aggregate total points from Employees per Team
        AggregateResult[] groupedResults = [
            SELECT Reference_to_Team__c teamId, SUM(Total_Points__c) totalPoints
            FROM Employee__c
            WHERE Reference_to_Team__c IN :teamIds
            GROUP BY Reference_to_Team__c
        ];

        Map<Id, Decimal> teamPointsMap = new Map<Id, Decimal>();
        for(AggregateResult ar : groupedResults) {
            teamPointsMap.put((Id)ar.get('teamId'), (Decimal)ar.get('totalPoints'));
        }

        // Teams that have no employees get 0
        for(Id teamId : teamIds) {
            if(!teamPointsMap.containsKey(teamId)) {
                teamPointsMap.put(teamId, 0);
            }
        }

        List<Team__c> teamsToUpdate = new List<Team__c>();
        for(Id teamId : teamPointsMap.keySet()) {
            teamsToUpdate.add(new Team__c(Id=teamId, Total_Points__c=teamPointsMap.get(teamId)));
        }

        if(!teamsToUpdate.isEmpty()) {
            update teamsToUpdate;
        }
    }
}
