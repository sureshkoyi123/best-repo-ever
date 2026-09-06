public with sharing class ContinuationController {
    //private static final String LONG_RUNNING_SERVICE_URL = WeatherAPI;
    @AuraEnabled(continuation=true cacheable=true)
    public static Object getWeather(){

        Continuation cont = new Continuation(60);
        cont.continuationMethod = 'processWeather';
        cont.state = 'Hello World';

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('callout:WeatherAPI_Legacy');
        cont.addHttpRequest(req);
        return cont;

    }

    @AuraEnabled(cacheable=true)
    public static String processWeather(List<String> labels, Object state){
        HttpResponse response= Continuation.getResponse(labels[0]);
        if(response.getStatusCode() == 200)
         return response.getBody();

         return 'Error: ' + response.getStatus();
    }
}