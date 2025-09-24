@isTest
public class ActionStatusTriggerTest {
    @isTest static void testEmployeeActionsStatusChangeOnActionFinished() {
        // Step 1: Create Action with status NOT Finished
        Action__c act = new Action__c(
            Name = 'Test Action',
            Status__c = 'Open Registration', // Different than Finished
            Base_Points__c = 100
        );
        insert act;

        // Step 2: Create Employee
        Employee__c emp = new Employee__c(
            First_Name__c = 'Test',
            Last_Name__c = 'User'
        );
        insert emp;

        // Step 3: Create EmployeeActions with various statuses
        EmployeeAction__c eaCompleted = new EmployeeAction__c(
            Reference_to_Action__c = act.Id,
            Reference_to_Employee__c = emp.Id,
            Status__c = 'Completed',
            Success_Metric__c = 100
        );

        EmployeeAction__c eaSignedUp = new EmployeeAction__c(
            Reference_to_Action__c = act.Id,
            Reference_to_Employee__c = emp.Id,
            Status__c = 'Signed up',
            Success_Metric__c = 0
        );

        EmployeeAction__c eaOther = new EmployeeAction__c(
            Reference_to_Action__c = act.Id,
            Reference_to_Employee__c = emp.Id,
            Status__c = 'Failed',
            Success_Metric__c = 0
        );

        insert new List<EmployeeAction__c>{ eaCompleted, eaSignedUp, eaOther };

        // Step 4: Update Action status to Finished to trigger your logic
        act.Status__c = 'Finished';

        Test.startTest();
        update act;  // Trigger fires here
        Test.stopTest();

        // Step 5: Query EmployeeActions to verify results
        List<EmployeeAction__c> updatedActions = [
            SELECT Id, Status__c FROM EmployeeAction__c WHERE Reference_to_Action__c = :act.Id
        ];

        // Step 6: Assert results
        for (EmployeeAction__c ea : updatedActions) {
            if (ea.Id == eaCompleted.Id) {
                System.assertEquals('Completed', ea.Status__c, 'Completed status should remain unchanged');
            } else {
                System.assertEquals('Failed', ea.Status__c, 'Status should be updated to Failed');
            }
        }
    }
}
