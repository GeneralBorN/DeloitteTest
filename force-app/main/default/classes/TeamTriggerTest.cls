@isTest
public class TeamTriggerTest {
    @isTest static void testRollupParentTeamPoints() {
        Team__c childTeam1 = new Team__c(Name='Child Team 1', Type__c='Team');
        insert childTeam1;

        Team__c parentOffice = new Team__c(Name='Parent Office', Type__c='Office');
        insert parentOffice;

        // Link child team to parent office
        childTeam1.Parent_Team__c = parentOffice.Id;
        update childTeam1;

        // Set Total Points on child team manually
        childTeam1.Total_Points__c = 200;
        update childTeam1;

        // Fire update by updating child team (simulate trigger)
        childTeam1.Name = 'Child Team 1 Updated';
        update childTeam1;

        parentOffice = [SELECT Total_Points__c FROM Team__c WHERE Id = :parentOffice.Id];
        System.assertEquals(200, parentOffice.Total_Points__c);
    }
}
