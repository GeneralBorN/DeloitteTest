trigger EmployeeTrigger on Employee__c (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
            TeamPointsRollupHandler.rollupTeamPoints(Trigger.new);
        }
        if(Trigger.isDelete){
            TeamPointsRollupHandler.rollupTeamPoints(Trigger.old);
        }
    }
}
