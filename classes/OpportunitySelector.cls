public inherited sharing class OpportunitySelector {
   public static List<Opportunity> getOpportunitiesWithProducts(Set<Id> opportunityIds, Set<Id> existingOrderOppIds){

    return [Select Id, AccountId, CloseDate, PriceBook2Id, (SELECT Id, OpportunityId, PricebookEntryId, Quantity, UnitPrice from OpportunityLineItems) from Opportunity WHERE Id IN :opportunityIds AND Id NOT IN :existingOrderOppIds];

   }

   /* public static List<Opportunity> selectForIntegration(Set<Id> opportunityIds){
    return [Select Id, AccountId, CloseDate, PriceBook2Id from Opportunity WHERE Id IN :opportunityIds];
   } */
}