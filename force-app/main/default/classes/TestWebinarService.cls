// Test class for WebinarService
public class TestWebinarService {

    // Manually construct the base URL using HTTPS protocol and domain context.
    static final String BASE_URL = 'https://orgfarm-5718a88f22-dev-ed.develop.lightning.force.com/services/apexrest/webinars';

    public static void testGetWebinars() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL + '/a01gK00000Kscw7QAB,a01gK00000KSpTuQAL'); // Replace with actual record IDs
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());

        Http http = new Http();
        HttpResponse res = http.send(req);

        // Log the response
        System.debug('Response Status: ' + res.getStatus());
        System.debug('Response Body: ' + res.getBody());
    }

    public static void testUpdateWebinar() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL);
        req.setMethod('PATCH');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');

        WebinarService.Webinar webinar = new WebinarService.Webinar();
        webinar.Id = 'a01gK00000Kscw7QAB'; // Add existing ID for update or leave null for create
        webinar.Name = 'Updated Name';
        webinar.Title = 'Updated Title';
        webinar.Description = 'Updated Description';
        webinar.ExternalID = '12345';
        webinar.NumberOfParticipants = 200;
        webinar.Price = 69.99;

        String requestBody = JSON.serialize(webinar);
        req.setBody(requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);

        // Log the response
        System.debug('Response Status: ' + res.getStatus());
        System.debug('Response Body: ' + res.getBody());
    }

    public static void testDeleteWebinar() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL + '/a01gK00000Kscw7QAB'); // Replace with actual record ID to delete
        req.setMethod('DELETE');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());

        Http http = new Http();
        HttpResponse res = http.send(req);

        // Log the response
        System.debug('Response Status: ' + res.getStatus());
        System.debug('Response Body: ' + res.getBody());
    }
}
