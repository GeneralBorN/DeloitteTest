@isTest
public class EmployeeTriggerTest {
    @isTest static void testRollupTeamPoints() {
        Team__c team = new Team__c(Name='Team A');
        insert team;

        Employee__c emp = new Employee__c(
            First_Name__c='Test', Last_Name__c='User',
            Reference_to_Team__c = team.Id,
            Total_Points__c = 100
        );
        insert emp;

        // Fire update by updating Employee (simulate trigger)
        emp.Last_Name__c = 'User2';
        update emp;

        team = [SELECT Total_Points__c FROM Team__c WHERE Id = :team.Id];
        System.assertEquals(100, team.Total_Points__c);
    }
}
