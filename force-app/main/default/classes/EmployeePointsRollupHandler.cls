public class EmployeePointsRollupHandler {
    public static void rollupEmployeePoints(List<EmployeeAction__c> employeeActions) {
        Set<Id> employeeIds = new Set<Id>();
        for(EmployeeAction__c ea : employeeActions) {
            if(ea.Reference_to_Employee__c != null) {
                employeeIds.add(ea.Reference_to_Employee__c);
            }
        }
        if(employeeIds.isEmpty()) return;

        AggregateResult[] groupedResults = [
            SELECT Reference_to_Employee__c empId, SUM(Calculated_Points__c) totalPoints
            FROM EmployeeAction__c
            WHERE Reference_to_Employee__c IN :employeeIds
            GROUP BY Reference_to_Employee__c
        ];

        Map<Id, Decimal> empPointsMap = new Map<Id, Decimal>();
        for(AggregateResult ar : groupedResults) {
            empPointsMap.put((Id)ar.get('empId'), (Decimal)ar.get('totalPoints'));
        }

        for(Id empId : employeeIds) {
            if(!empPointsMap.containsKey(empId)) {
                empPointsMap.put(empId, 0);
            }
        }

        List<Employee__c> empsToUpdate = new List<Employee__c>();
        for(Id empId : empPointsMap.keySet()) {
            empsToUpdate.add(new Employee__c(Id=empId, Total_Points__c=empPointsMap.get(empId)));
        }

        if(!empsToUpdate.isEmpty()) {
            update empsToUpdate;
        }
    }
}
