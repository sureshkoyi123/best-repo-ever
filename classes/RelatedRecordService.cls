public with sharing class RelatedRecordService {
     /**
     * Detect Opportunity transition to Closed Won
     * and enqueue asynchronous Order creation.
     */
    public static void handleClosedWon(List<Opportunity> newOpps, Map<Id,Opportunity> oldMap){
        if(newOpps == null || newOpps.isEmpty() || oldMap == null){
            return;
        }

        Set<Id> opportunityIds = new Set<Id>();
        
        for(Opportunity opp : newOpps){
            Opportunity oldOpp = oldMap.get(opp.Id);

            if(oldOpp != null && oldOpp.StageName != OpportunityConstants.STAGE_CLOSED_WON && opp.StageName== OpportunityConstants.STAGE_CLOSED_WON){
                opportunityIds.add(opp.Id);
            }
        }

        if(opportunityIds.isEmpty()){
            return;
        }
     
        System.debug('Before order creation enqueque job');
        if(!opportunityIds.isEmpty()){
            System.enqueueJob(new OrderCreationQueueable(opportunityIds));
           
            System.debug('After order creation enqueque job');
        }
    }
     /**
     * Runs from Queueable.
     * Creates Orders and OrderItems.
     */
    public static void createOrders(Set<Id> opportunityIds){

    if(opportunityIds == null || opportunityIds.isEmpty()){
        return;
    }

    Set<Id> existingOrderOppIds = OrderSelector.getExistingOrderOpportunityIds(opportunityIds);
    //Set<Id> successfulOrderIds = new Set<Id>();
    List<Opportunity> opportunities = OpportunitySelector.getOpportunitiesWithProducts(opportunityIds, existingOrderOppIds);

    List<Order> ordersToInsert = new List<Order>();
    
    Map<Id, Id> oppToOrderId = new Map<Id, Id>();

    for(Opportunity opp : opportunities){
        if(opp.AccountId == null){
            continue;
        }
        /* if(existingOrderOppIds.contains(opp.Id)){
            continue;
        } */
        Order ord = new Order(
            
            AccountId = opp.AccountId,
            Source_Opportunity__c = opp.Id,
            Pricebook2Id = opp.Pricebook2Id,
            EffectiveDate = opp.CloseDate,
            Status = OrderConstants.STATUS_DRAFT            
        );

        ordersToInsert.add(ord);
       

    }

    if(!ordersToInsert.isEmpty()){
       

            Database.SaveResult[] orderResult = Database.insert(ordersToInsert, false);
            oppToOrderId = getSuccessfulOrderIds(orderResult, ordersToInsert);
            
     
    }   
    if (oppToOrderId.isEmpty()) {
    return;
}
    List<OrderItem> orderItemsToInsert = new List<OrderItem>();

    for(Opportunity opp : opportunities){

        Id parentOrderId = oppToOrderId.get(opp.Id);
        if(parentOrderId == null){
            continue;
        }

        for(OpportunityLineItem oli : opp.OpportunityLineItems){

            
            orderItemsToInsert.add(new OrderItem(
                OrderId = parentOrderId,
                PricebookEntryId = oli.PricebookEntryId,
                Quantity = oli.Quantity,
                UnitPrice = oli.UnitPrice
            ));

        }
    }

    if(!orderItemsToInsert.isEmpty()){
        try{
        Database.SaveResult[] orderItems = Database.insert(orderItemsToInsert, false);
        Boolean hasFailures = false;
        for(integer i=0; i<orderItems.size(); i++){
            if(!orderItems[i].isSuccess()){
                hasFailures = true;
                break;
            }

            

        }
        if(hasFailures){
                return;
        }
        //OrderIntegrationQueueable
        enqueueOrderIntegration(new Set<Id>(oppToOrderId.values()));
        //System.enqueueJob(new OrderIntegrationQueueable(new Set<Id>(oppToOrderId.values())));
        
        }
        catch(DmlException ex){
            
            //log error
        }
    }


    
   }
   private static Map<Id, Id> getSuccessfulOrderIds(Database.SaveResult[] saveResults, List<Order> orders){

    Map<Id, Id> oppToOrderId = new Map<Id, Id>();
    for(integer i=0; i<saveResults.size(); i++){

        if(saveResults[i].isSuccess()){
           
            oppToOrderId.put(orders[i].Source_Opportunity__c, saveResults[i].getId());

        }
        else{

            for(Database.Error error : saveResults[i].getErrors()){
                // TODO: IntegrationLogService.markFailure(...)
                System.debug('Order Failed: ' + error.getMessage());
            }

        }

       
    }
    return oppToOrderId;


   }
private static void enqueueOrderIntegration(Set<Id> orderIds){
    

    if(!orderIds.isEmpty()){

        System.enqueueJob(
            new OrderIntegrationQueueable(orderIds)
        );
    }
   } 


}