public class getPriceFromExternalTool {
    @future(callout=true)
    public static void getPrice(String externalId, Id webinarId) {
        Decimal price;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://109.95.171.99/calculatePrice/' + externalId);
        request.setMethod('GET');
        
        try {
            HttpResponse response = http.send(request);
            System.debug('Response Status Code: ' + response.getStatusCode());
            System.debug('Response Body: ' + response.getBody());

            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                
                try {
                    price = Decimal.valueOf(responseBody);
                } catch (Exception e) {
                    System.debug('Failed to convert responseBody to decimal: ' + responseBody);
                }
            } else {
                System.debug('Non-200 status code received: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('HTTP callout failed: ' + e.getMessage());
        }
        
        if (price != null) {
            try {
                Webinar__c webinar = [SELECT Id, Price__c FROM Webinar__c WHERE Id = :webinarId];
                webinar.Price__c = price;
                update webinar;
                System.debug('Price Updated Successfully: ' + webinar.Price__c);
            } catch (Exception e) {
                System.debug('Update Failure: ' + e.getMessage());
            }
        } else {
            System.debug('Price is null after callout.');
        }
    }
}
