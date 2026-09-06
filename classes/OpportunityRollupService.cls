public with sharing class OpportunityRollupService {
    
    public static void updateAccountRollups(Set<Id> accountIds){


        if(accountIds == null || accountIds.isEmpty()) return;

        List<AggregateResult> results = [SELECT AccountId accId, SUM(Amount) totalAmount, 
                                                Count(Id) totalCount, MAX(CloseDate) latestDate
                                                FROM Opportunity Where AccountId IN :accountIds AND 
                                                StageName = 'Closed Won' GROUP BY AccountId];
        Map<Id,Account> accountsToUpdate = new Map<Id,Account>();

        for(AggregateResult ar : results){
            Id accId = (Id) ar.get('accId');
            accountsToUpdate.put(accId, new Account(
                Id = accId,
                Total_Won_Amount__c = (Decimal)ar.get('totalAmount'),
                Won_Opportunity_Count__c = (Integer)ar.get('totalCount'),
                Latest_Won_Date__c = (Date) ar.get('latestDate')
            ));
        }

        if(!accountsToUpdate.isEmpty())
            update accountsToUpdate.values();
          

    }
}