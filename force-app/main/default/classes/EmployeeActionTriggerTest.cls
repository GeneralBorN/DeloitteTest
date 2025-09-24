@isTest
public class EmployeeActionTriggerTest {
    @isTest static void testNamePopulationAndPointsRollup() {
        // Create Employee
        Employee__c emp = new Employee__c(First_Name__c='Jan', Last_Name__c='Kowalski');
        insert emp;

        // Create Action
        Action__c act = new Action__c(Name='Warsaw Marathon', Base_Points__c=100);
        insert act;

        // Create EmployeeAction with Status Completed and Success Metric 50%
        EmployeeAction__c ea = new EmployeeAction__c(
            Reference_to_Employee__c = emp.Id,
            Reference_to_Action__c = act.Id,
            Status__c = 'Completed',
            Success_Metric__c = 50,
            Calculated_Points__c = 50 // assuming this is set manually or by workflow/formula
        );

        Test.startTest();
        insert ea;
        Test.stopTest();

        // Query inserted EmployeeAction to check Name field autopopulated
        ea = [SELECT Name FROM EmployeeAction__c WHERE Id = :ea.Id];
        System.assertEquals('Jan Kowalski | Warsaw Marathon', ea.Name, 'Name field should be autopopulated');

        // Query Employee to check Total Points roll-up
        emp = [SELECT Total_Points__c FROM Employee__c WHERE Id = :emp.Id];
        System.assertEquals(50, emp.Total_Points__c, 'Employee total points should equal calculated points from EmployeeAction');

        // Now test updating EmployeeAction calculated points and see if rollup updates
        ea.Calculated_Points__c = 80;
        Test.startTest();
        update ea;
        Test.stopTest();

        emp = [SELECT Total_Points__c FROM Employee__c WHERE Id = :emp.Id];
        System.assertEquals(80, emp.Total_Points__c, 'Employee total points should update after EmployeeAction update');

        // Test deletion of EmployeeAction resets Employee total points to 0
        Test.startTest();
        delete ea;
        Test.stopTest();

        emp = [SELECT Total_Points__c FROM Employee__c WHERE Id = :emp.Id];
        System.assertEquals(0, emp.Total_Points__c, 'Employee total points should be 0 after deleting EmployeeAction');
    }
}
