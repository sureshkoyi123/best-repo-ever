public with sharing class TriggerRecursionGuard{
    
    private static Set<Id> processedOpportunityIds = new Set<Id>();

    public static Set<Id> getUnprocessedOpportunityIds(Set<Id> ids){
        System.debug('Incoming Ids: ' + ids);
        System.debug('Already Processed: ' + processedOpportunityIds);
        
        if(ids == null || ids.isEmpty()){
            return new Set<Id>();
        }

        Set<Id> unprocessedIds = ids.clone();
        unprocessedIds.removeAll(processedOpportunityIds);

        if(!unprocessedIds.isEmpty()){
            processedOpportunityIds.addAll(unprocessedIds);
        }

        return unprocessedIds;

    }
}