trigger ActionStatusTrigger on Action__c (after update) {
    // Call handler
    ActionStatusHandler.handleStatusChangeToFinished(Trigger.oldMap, Trigger.newMap);
}
