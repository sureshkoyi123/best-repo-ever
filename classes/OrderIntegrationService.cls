public with sharing class OrderIntegrationService {

    public static void processSync(Set<Id> orderIds){

        if(orderIds == null || orderIds.isEmpty()){
            return;
        }

    List<Order> orders = OrderSelector.selectOrdersForIntegration(orderIds);

    if(orders == null || orders.isEmpty()){
        return;
    }
    
    OrderSyncRequest payload = new OrderSyncRequest(orders);
    String jsonPayload = JSON.serialize(payload);
    String transactionId = 'Ord-' + String.valueOf(System.now().getTime());
    Integration_Log__c log = IntegrationLogService.createLog(
        transactionId, 'Order','Order Sync',orders.size(),jsonPayload, orderIds
    );

    try{

    HttpResponse response = IntegrationCalloutService.sendOrders(jsonPayload);

    
  
    if(response.getStatusCode() >=200 && response.getStatusCode() <300){
        IntegrationLogService.markSuccess(log, response.getBody());
    }
    else{

        IntegrationLogService.markFailure(log, response==null? 'No Response' : response.getBody());
        
    }
}
catch(Exception ex){
    IntegrationLogService.markFailure(log, ex.getMessage());
}
            
    }
}