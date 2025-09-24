trigger EmployeeActionTrigger on EmployeeAction__c (before insert, after insert, after update, after delete, after undelete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        EmployeeActionHandler.populateNameField(Trigger.new);
    }

    if(Trigger.isAfter) {
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
            EmployeePointsRollupHandler.rollupEmployeePoints(Trigger.new);
        }
        if(Trigger.isDelete) {
            EmployeePointsRollupHandler.rollupEmployeePoints(Trigger.old);
        }
    }
}
