public class getPriceFromExternalTool {

    @future(callout=true)
    public static void fetchAndSetWebinarPrice(Id webinarId, String externalId) {
        String endpoint = 'http://109.95.171.99/calculatePrice/' + externalId;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        
        try {
            HttpResponse response = http.send(request);

            System.debug('HTTP Response Code: ' + response.getStatusCode());
            System.debug('HTTP Response Body: ' + response.getBody());
            
            if (response.getStatusCode() == 200) {
                // The response body is a plain decimal as a string
                String responseBody = response.getBody().trim();
                Decimal price = Decimal.valueOf(responseBody);

                Webinar__c webinar = [SELECT Id, Price__c FROM Webinar__c WHERE Id = :webinarId LIMIT 1];
                    System.debug('Current Webinar Price before update: ' + webinar.Price__c);
                    // Set the new price
                    webinar.Price__c = price;

                    try {
                        update webinar;
                        System.debug('Webinar object updated successfully with new price: ' + webinar.Price__c);
                    } catch (DmlException e) {
                        System.debug('DML Exception: ' + e.getMessage());
                    }

            } else {
                throw new CalloutException('HTTP request failed with status: ' + response.getStatusCode());
            }
        } catch (CalloutException e) {
            System.debug('CalloutException in getPriceFromExternalTool: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('Unexpected error: ' + e.getMessage());
        }
    }
}
