public with sharing class TeamRankingController {

    public class EmployeeWrapper {
        @AuraEnabled public Id employeeId;
        @AuraEnabled public String employeeName;
        @AuraEnabled public Integer participatedEvents;
        @AuraEnabled public Decimal totalPoints;
    }

    public class TeamWrapper {
        @AuraEnabled public Integer position;
        @AuraEnabled public Id teamId;
        @AuraEnabled public String teamName;
        @AuraEnabled public Integer numberOfEmployees;
        @AuraEnabled public Decimal totalPoints;
        @AuraEnabled public List<EmployeeWrapper> employees;
    }

    @AuraEnabled(cacheable=true)
    public static List<TeamWrapper> getTeamRanking(String searchTerm, Integer offsetNum, Integer limitNum) {
        String filter = (searchTerm != null && searchTerm.trim() != '') ? '%' + searchTerm.trim() + '%' : null;
        Integer limitVal = limitNum != null ? limitNum : 10;
        Integer offsetVal = offsetNum != null ? offsetNum : 0;

        String baseQuery = 'SELECT Id, Name, Total_Points__c FROM Team__c WHERE Type__c = \'Team\' ';

        if (filter != null) {
            baseQuery += 'AND Name LIKE :filter ';
        }

        baseQuery += 'ORDER BY Total_Points__c DESC LIMIT :limitVal OFFSET :offsetVal';

        // Use Database.query with binding for filter, limitVal, offsetVal
        List<Team__c> teams;

        if (filter != null) {
            teams = Database.query(baseQuery);
        } else {
            // If no filter, remove the binding for filter
            baseQuery = 'SELECT Id, Name, Total_Points__c FROM Team__c WHERE Type__c = \'Team\' ORDER BY Total_Points__c DESC LIMIT :limitVal OFFSET :offsetVal';
            teams = Database.query(baseQuery);
        }

        // But wait, Database.query doesn't allow binding variables directly,
        // so we need to use string concatenation carefully with limits and offsets

        // So let's fix by building the full string with limits and offsets as integers:

        if (filter != null) {
            // Escaping the filter string properly
            String escapedFilter = String.escapeSingleQuotes(filter);
            String queryWithFilter = 'SELECT Id, Name, Total_Points__c FROM Team__c WHERE Type__c = \'Team\' AND Name LIKE \'' + escapedFilter + '\' ORDER BY Total_Points__c DESC LIMIT ' + limitVal + ' OFFSET ' + offsetVal;
            teams = Database.query(queryWithFilter);
        } else {
            String queryWithoutFilter = 'SELECT Id, Name, Total_Points__c FROM Team__c WHERE Type__c = \'Team\' ORDER BY Total_Points__c DESC LIMIT ' + limitVal + ' OFFSET ' + offsetVal;
            teams = Database.query(queryWithoutFilter);
        }

        // Then continue with the rest as before...

        Set<Id> teamIds = new Set<Id>();
        for(Team__c t : teams) {
            teamIds.add(t.Id);
        }

        Map<Id, Integer> employeeCountMap = new Map<Id, Integer>();
        for (AggregateResult ar : [
            SELECT Reference_to_Team__c teamId, COUNT(Id) empCount
            FROM Employee__c
            WHERE Reference_to_Team__c IN :teamIds
            GROUP BY Reference_to_Team__c
        ]) {
            employeeCountMap.put((Id)ar.get('teamId'), (Integer)ar.get('empCount'));
        }

        List<TeamWrapper> result = new List<TeamWrapper>();
        Integer positionCounter = offsetVal + 1;
        for (Team__c t : teams) {
            TeamWrapper tw = new TeamWrapper();
            tw.teamId = t.Id;
            tw.teamName = t.Name;
            tw.totalPoints = t.Total_Points__c != null ? t.Total_Points__c : 0;
            tw.numberOfEmployees = employeeCountMap.containsKey(t.Id) ? employeeCountMap.get(t.Id) : 0;
            tw.employees = getEmployeesForTeam(t.Id);
            tw.position = positionCounter++;
            result.add(tw);
        }
        return result;
    }


    // Helper method to get employee details per team
    public static List<EmployeeWrapper> getEmployeesForTeam(Id teamId) {
        List<EmployeeWrapper> employees = new List<EmployeeWrapper>();

        List<Employee__c> empRecords = [
            SELECT Id, First_Name__c, Last_Name__c,
                (SELECT Id, Calculated_Points__c FROM EmployeeActions__r)
            FROM Employee__c
            WHERE Reference_to_Team__c = :teamId
        ];


        // For each employee, calculate events and points
        for(Employee__c emp : empRecords) {
            EmployeeWrapper ew = new EmployeeWrapper();
            ew.employeeId = emp.Id;
            ew.employeeName = emp.First_Name__c + ' ' + emp.Last_Name__c;

            // Count EmployeeActions__r for events count
            ew.participatedEvents = emp.EmployeeActions__r != null ? emp.EmployeeActions__r.size() : 0;

            // Sum Calculated Points from EmployeeActions__r
            Decimal totalPoints = 0;
            if(emp.EmployeeActions__r != null){
                for(EmployeeAction__c ea : emp.EmployeeActions__r){
                    if(ea.Calculated_Points__c != null){
                        totalPoints += ea.Calculated_Points__c;
                    }
                }
            }
            ew.totalPoints = totalPoints;

            employees.add(ew);
        }

        return employees;
    }

    // Optional: Method to get total number of Teams for pagination
    @AuraEnabled(cacheable=true)
    public static Integer getTotalTeamsCount(String searchTerm) {
        Boolean hasSearch = searchTerm != null && searchTerm.trim() != '';
        String baseQuery = 'SELECT COUNT() FROM Team__c WHERE Type__c = \'Team\'';
        
        if (hasSearch) {
            String escapedFilter = String.escapeSingleQuotes('%' + searchTerm.trim() + '%');
            baseQuery += ' AND Name LIKE \'' + escapedFilter + '\'';
        }
        System.debug('Running count query: ' + baseQuery);
        return Database.countQuery(baseQuery);
    }

}