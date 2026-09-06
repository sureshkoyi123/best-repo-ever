public with sharing class OpportunityBusinessService {

    public static void processBeforeInsert(List<Opportunity> newOpps){

    }

    public static void processBeforeUpdate(List<Opportunity> newOpps, Map<Id,Opportunity> oldMap){
        OpportunityValidationService.validateClosedWon(newOpps, oldMap);
    }

    public static void processBeforeDelete(List<Opportunity> oldOpps){

    }

    public static void processAfterInsert(List<Opportunity> newOpps){
        Set<Id> accountIds = extractAccountIds(newOpps);      
        triggerRollup(accountIds);
    }

    public static void processAfterUpdate(List<Opportunity> newOpps, Map<Id,Opportunity> oldMap){
        Map<Id,Opportunity> newMap = new Map<Id,Opportunity>(newOpps);
        Set<Id> unprocessedIds = TriggerRecursionGuard.getUnprocessedOpportunityIds(newMap.keySet());
        if(unprocessedIds.isEmpty()){
            return;
        }
        List<Opportunity> filteredOpps = new List<Opportunity>();

        for(Id oppId : unprocessedIds){
            Opportunity opp = newMap.get(oppId);
            if(opp != null){
                filteredOpps.add(opp);
            }
            
        }
        Set<Id> accountIds = extractAccountIds(filteredOpps, oldMap);    
        triggerRollup(accountIds);  
        RelatedRecordService.handleClosedWon(filteredOpps, oldMap);    
        //OpportunityIntegrationService.enqueueSync(filteredOpps, oldMap);
    }

    public static void processAfterDelete(List<Opportunity> oldOpps){

        Set<Id> accountIds = extractAccountIds(oldOpps);
        triggerRollup(accountIds);
        
    }

    public static void processAfterUndelete(List<Opportunity> newOpps){
        Set<Id> accountIds = extractAccountIds(newOpps);   
        triggerRollup(accountIds);

    }

    private static void triggerRollup(Set<Id> accountIds) {

    if (accountIds == null || accountIds.isEmpty()) {
        return;
    }

    OpportunityRollupService.updateAccountRollups(accountIds);
    }

    private static Set<Id> extractAccountIds(List<Opportunity> opps){

        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : opps){
            if(opp.AccountId != null){
                accountIds.add(opp.AccountId);
            }
        }

        return accountIds;

    }

    private static Set<Id> extractAccountIds(List<Opportunity> newOpps, Map<Id, Opportunity> oldMap){

        Set<Id> accountIds = new Set<Id>();

        for(Opportunity opp : newOpps){

            if(opp.AccountId != null){
                accountIds.add(opp.AccountId);
            }

            if(oldMap != null && oldMap.containsKey(opp.Id)){
                Opportunity oldOpp = oldMap.get(opp.Id);
                if(oldOpp.AccountId != null){
                    accountIds.add(oldOpp.AccountId);
                }
            }
        }

        return accountIds;

    }

    
}