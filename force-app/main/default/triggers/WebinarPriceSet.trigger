trigger WebinarPriceSet on Webinar__c (after insert, after update) {
    for (Webinar__c webinar : Trigger.new) {
        if (webinar.External_ID__c != null) {
            // Call the future method
            getPriceFromExternalTool.getPrice(webinar.External_ID__c, webinar.Id);
        }
    }
}
