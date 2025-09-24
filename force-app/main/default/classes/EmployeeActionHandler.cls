public class EmployeeActionHandler {
    public static void populateNameField(List<EmployeeAction__c> employeeActions) {
        Set<Id> employeeIds = new Set<Id>();
        Set<Id> actionIds = new Set<Id>();

        for(EmployeeAction__c ea : employeeActions) {
            if(ea.Reference_to_Employee__c != null) employeeIds.add(ea.Reference_to_Employee__c);
            if(ea.Reference_to_Action__c != null) actionIds.add(ea.Reference_to_Action__c);
        }

        Map<Id, Employee__c> employees = new Map<Id, Employee__c>([
            SELECT Id, First_Name__c, Last_Name__c FROM Employee__c WHERE Id IN :employeeIds
        ]);

        Map<Id, Action__c> actions = new Map<Id, Action__c>([
            SELECT Id, Name FROM Action__c WHERE Id IN :actionIds
        ]);

        for(EmployeeAction__c ea : employeeActions) {
            if(ea.Reference_to_Employee__c != null && ea.Reference_to_Action__c != null) {
                Employee__c emp = employees.get(ea.Reference_to_Employee__c);
                Action__c act = actions.get(ea.Reference_to_Action__c);
                if(emp != null && act != null) {
                    ea.Name = emp.First_Name__c + ' ' + emp.Last_Name__c + ' | ' + act.Name;
                }
            }
        }
    }
}
