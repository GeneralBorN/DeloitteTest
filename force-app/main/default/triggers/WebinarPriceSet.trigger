trigger WebinarPriceSet on Webinar__c (before insert, before update) {
    for (Webinar__c webinar : Trigger.new) {
        // Call the @future method
        if (Trigger.isInsert || (Trigger.isUpdate && webinar.External_Id__c != Trigger.oldMap.get(webinar.Id).External_Id__c)) {
            // Asynchronous call to fetch and set price
            getPriceFromExternalTool.fetchAndSetWebinarPrice(webinar.Id, webinar.External_Id__c);
            System.debug('Trigger is triggered and fetch was performed');
        }
    }
}
