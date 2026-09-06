public inherited sharing class OrderSelector {
    public static Set<Id> getExistingOrderOpportunityIds(Set<Id> opportunityIds){
        Set<Id> existingOrderOppIds = new Set<Id>();

    for(Order ord : [SELECT Source_Opportunity__c from Order WHERE Source_Opportunity__c IN :opportunityIds])
        {
            existingOrderOppIds.add(ord.Source_Opportunity__c);
        }

        return existingOrderOppIds;
    }

   
    public static List<Order> selectOrdersForIntegration(Set<Id> orderIds){

        return [SELECT Id, OrderNumber, Source_Opportunity__c, PriceBook2Id, AccountId, EffectiveDate, Status,(Select Id, PriceBookEntryId, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, Quantity, UnitPrice FROM OrderItems) from Order WHERE Id IN :orderIds];

    }
}