public with sharing class IntegrationCalloutService {
    
    public static HttpResponse sendOrders(String jsonPayload){
        if(String.isBlank(jsonPayload)){
            return null;
        }
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(IntegrationConstants.ERP_ORDER_ENDPOINT);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');        
        //System.debug(JSON.serializePretty(payload));
        req.setBody(jsonPayload);

        Http http = new Http();
        return http.send(req);

    }
}