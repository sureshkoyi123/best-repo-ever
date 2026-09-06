public with sharing class RetryIntegrationBatch implements Database.Batchable<SObject>, Database.Stateful{
    
    public Database.QueryLocator start(Database.BatchableContext bc){

        return Database.getQueryLocator(
            [
                SELECT Id,                   
                   Record_Ids__c,
                   Retry_Count__c,
                   Status__c,
                   Next_Run_Time__c,
                   Last_Attempt_Time__c
            FROM Integration_Log__c
            WHERE Status__c = 'Failed'
            AND Retry_Count__c < 3
            AND Next_Run_Time__c <= :System.now()
            ]
        );

    }

    public void execute(Database.BatchableContext bc, List<SObject> scope){
        Set<Id> orderIds = new Set<Id>();
        List<Integration_Log__c> logs = (List<Integration_Log__c>) scope;

        for(Integration_Log__c log : logs){

            log.Status__c = 'In Progress';           
            log.Last_Attempt_Time__c = System.now();
            // log.Next_Run_Time__c = getNextRunTime(log.Retry_Count__c);
            // log.Retry_Count__c += 1;
            
            if(String.isNotBlank(log.Record_Ids__c)){
            orderIds.addAll((Set<Id>)JSON.deserialize(log.Record_Ids__c, Set<Id>.class));
            }
        }
        update logs;
        if(!orderIds.isEmpty()){
            
            System.enqueueJob(new OrderIntegrationQueueable(orderIds));
        }

    }


    public void finish(Database.BatchableContext bc){

    }


}