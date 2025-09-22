@RestResource(urlMapping='/webinars/*')
global with sharing class WebinarService {

    // Method to retrieve data about a particular Webinar or a list of Webinars
    @HttpGet
    global static void getWebinars() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        List<String> webinarIds = new List<String>();
        
        // Check if webinar ids are provided in the request
        if (!String.isBlank(req.requestBody.toString())) {
            // Assuming the request body contains a list of Webinar IDs
            Map<String, Object> body = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
            if (body.containsKey('ids') && body.get('ids') instanceof List<Object>) {
                webinarIds = (List<String>) body.get('ids');
            }
        }
        
        try {
            List<Webinar__c> webinars;
            if(webinarIds.isEmpty()) {
                webinars = [SELECT Id, Name, Description__c FROM Webinar__c];
            } else {
                webinars = [SELECT Id, Name, Description__c FROM Webinar__c WHERE Id IN :webinarIds];
            }
            res.statusCode = 200;
            res.responseBody = Blob.valueOf(JSON.serialize(webinars));
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error":"' + e.getMessage() + '"}');
        }
    }

    // Method to add new Webinar records
    @HttpPost
    global static void createWebinar() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            Webinar__c newWebinar = (Webinar__c) JSON.deserialize(req.requestBody.toString(), Webinar__c.class);
            insert newWebinar;
            res.statusCode = 201;
            res.responseBody = Blob.valueOf('{"success":true, "id":"'+newWebinar.Id+'"}');
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error":"' + e.getMessage() + '"}');
        }
    }
    
    // Method to edit Webinar records
    @HttpPatch
    global static void updateWebinar() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            Webinar__c updatedWebinar = (Webinar__c) JSON.deserialize(req.requestBody.toString(), Webinar__c.class);
            update updatedWebinar;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('{"success":true}');
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error":"' + e.getMessage() + '"}');
        }
    }
    
    // Method to remove Webinar records
    @HttpDelete
    global static void deleteWebinar() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            Webinar__c webinarToDelete = (Webinar__c) JSON.deserialize(req.requestBody.toString(), Webinar__c.class);
            delete webinarToDelete;
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('{"success":true}');
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error":"' + e.getMessage() + '"}');
        }
    }
}

/* TESTING
============================================================================================================================================================

String baseUrl = URL.getOrgDomainUrl().toExternalForm();
HttpRequest req = new HttpRequest();
req.setEndpoint(baseUrl + '/services/apexrest/webinars/');
req.setMethod('GET');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
HttpResponse res = new Http().send(req);
System.debug('Response Status: ' + res.getStatus());
System.debug('Response Body: ' + res.getBody());

============================================================================================================================================================

String baseUrl = URL.getOrgDomainUrl().toExternalForm();
HttpRequest req = new HttpRequest();
req.setEndpoint(baseUrl + '/services/apexrest/webinars/');
req.setMethod('POST');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
req.setHeader('Content-Type', 'application/json');

Webinar__c newWebinar = new Webinar__c(Name = 'New Webinar', Description__c = 'This is a test webinar');
req.setBody(JSON.serialize(newWebinar));

HttpResponse res = new Http().send(req);
System.debug('Response Status: ' + res.getStatus());
System.debug('Response Body: ' + res.getBody());

============================================================================================================================================================

String baseUrl = URL.getOrgDomainUrl().toExternalForm();
HttpRequest req = new HttpRequest();
req.setEndpoint(baseUrl + '/services/apexrest/webinars/');
req.setMethod('PATCH');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
req.setHeader('Content-Type', 'application/json');

Webinar__c updatedWebinar = new Webinar__c(Id = 'a01gK00000Ky9wCQAR', Description__c = 'Updated description');
req.setBody(JSON.serialize(updatedWebinar));

HttpResponse res = new Http().send(req);
System.debug('Response Status: ' + res.getStatus());
System.debug('Response Body: ' + res.getBody());

============================================================================================================================================================

String baseUrl = URL.getOrgDomainUrl().toExternalForm();
HttpRequest req = new HttpRequest();
req.setEndpoint(baseUrl + '/services/apexrest/webinars/');
req.setMethod('DELETE');
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
req.setHeader('Content-Type', 'application/json');

Webinar__c webinarToDelete = new Webinar__c(Id = 'a01gK00000Ky9wCQAR');
req.setBody(JSON.serialize(webinarToDelete));

HttpResponse res = new Http().send(req);
System.debug('Response Status: ' + res.getStatus());
System.debug('Response Body: ' + res.getBody());

============================================================================================================================================================
*/