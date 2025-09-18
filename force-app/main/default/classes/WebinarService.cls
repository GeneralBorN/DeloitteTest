@RestResource(urlMapping='/webinars/*')
global with sharing class WebinarService {
    
    // Webinar object schema
    global class Webinar {
        public String Id;
        public String Name;
        public String Title;
        public String Description;
        public String ExternalID;
        public Decimal NumberOfParticipants;
        public Decimal Price;
    }

    // Method to retrieve Webinar data based on Ids
    @HttpGet
    global static List<Webinar> getWebinars() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String idsParam = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        // Handle case of empty request
        if (String.isEmpty(idsParam)) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Missing Webinar Ids');
            return null;
        }

        List<String> webinarIds = idsParam.split(',');
        List<Webinar__c> webinarRecords = [SELECT Id, Name, Title__c, Description__c, 
                                            External_ID__c, Number_of_participants__c, Price__c 
                                            FROM Webinar__c WHERE Id IN :webinarIds];
        
        List<Webinar> result = new List<Webinar>();
        for (Webinar__c record : webinarRecords) {
            Webinar webinarData = new Webinar();
            webinarData.Id = record.Id;
            webinarData.Name = record.Name;
            webinarData.Title = record.Title__c;
            webinarData.Description = record.Description__c;
            webinarData.ExternalID = record.External_ID__c;
            webinarData.NumberOfParticipants = record.Number_of_participants__c;
            webinarData.Price = record.Price__c;
            result.add(webinarData);
        }
        
        return result;
    }

    // Method to add/edit Webinar records
    @HttpPatch
    global static String updateWebinar() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Webinar updatedWebinar = (Webinar)JSON.deserialize(req.requestBody.toString(), Webinar.class);
        
        Webinar__c webinarRecord;
        if (String.isNotBlank(updatedWebinar.Id)) {
            webinarRecord = [SELECT Id FROM Webinar__c WHERE Id = :updatedWebinar.Id LIMIT 1];
        } else {
            webinarRecord = new Webinar__c();
        }

        webinarRecord.Name = updatedWebinar.Name;
        webinarRecord.Title__c = updatedWebinar.Title;
        webinarRecord.Description__c = updatedWebinar.Description;
        webinarRecord.External_ID__c = updatedWebinar.ExternalID;
        webinarRecord.Number_of_participants__c = updatedWebinar.NumberOfParticipants;
        webinarRecord.Price__c = updatedWebinar.Price;
        upsert webinarRecord;

        return webinarRecord.Id;
    }

    // Method to remove Webinar records
    @HttpDelete
    global static void deleteWebinar() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        try {
            Webinar__c webinarRecord = [SELECT Id FROM Webinar__c WHERE Id = :id LIMIT 1];
            delete webinarRecord;
        } catch (Exception e) {
            res.statusCode = 404;
            res.responseBody = Blob.valueOf('Webinar not found');
        }
    }
}
