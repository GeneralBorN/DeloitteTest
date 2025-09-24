public class ActionStatusHandler {
    public static void handleStatusChangeToFinished(Map<Id, Action__c> oldMap, Map<Id, Action__c> newMap) {
        Set<Id> finishedActionIds = new Set<Id>();

        for (Id actionId : newMap.keySet()) {
            Action__c oldAction = oldMap.get(actionId);
            Action__c newAction = newMap.get(actionId);

            if (oldAction.Status__c != 'Finished' && newAction.Status__c == 'Finished') {
                finishedActionIds.add(actionId);
            }
        }

        if (finishedActionIds.isEmpty()) return;
        
        List<EmployeeAction__c> toUpdate = [
            SELECT Id, Status__c
            FROM EmployeeAction__c
            WHERE Reference_to_Action__c IN :finishedActionIds
            AND Status__c != 'Completed'
        ];

        for (EmployeeAction__c ea : toUpdate) {
            ea.Status__c = 'Failed';
        }

        if (!toUpdate.isEmpty()) {
            update toUpdate;
        }
    }
}
