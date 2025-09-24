trigger TeamTrigger on Team__c (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
            ParentTeamPointsRollupHandler.rollupParentTeamPoints(Trigger.new);
        }
        if(Trigger.isDelete){
            ParentTeamPointsRollupHandler.rollupParentTeamPoints(Trigger.old);
        }
    }
}
