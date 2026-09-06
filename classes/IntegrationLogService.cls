public with sharing class IntegrationLogService {

    public static Integration_Log__c createLog(
        String transactionId,
        String objectName,
        String integrationType,
        Integer recordCount,
        String requestPayload,
        Set<Id> orderIds
    ){

        Integration_Log__c log = new Integration_Log__c(
            Transaction_Id__c = transactionId,            
            Object_Name__c = objectName,
            Integration_Type__c = integrationType,
            Record_Ids__c = JSON.serialize(orderIds),
            Record_Count__c = recordCount,
            Status__c = 'In Progress',
            Request_Payload__c = requestPayload,
            Retry_Count__c = 0,
            Last_Attempt_Time__c = System.now()
        );

        insert log;

        return log;
    }
    


    public static void markSuccess(
        Integration_Log__c log,
        String response
    ){       
           
            log.Status__c = 'Success';
            log.Response_Body__c = response;     

            update log;
    }


    public static void markFailure(
        Integration_Log__c log,
        String errorMessage
            ){
                
            if (log.Retry_Count__c >= 3) {
            log.Status__c = 'Permanent Failure'; 
            log.Next_Run_Time__c = null;
        } else {
            log.Status__c = 'Failed';
            log.Next_Run_Time__c = getNextRunTime(Integer.valueOf(log.Retry_Count__c));
            log.Retry_Count__c++;
        }     

        update log;
    }


    private static Datetime getNextRunTime(Integer retryCount){

        Datetime nextRunTime;
        switch on retryCount{
            when 0 { nextRunTime = System.now().addMinutes(15);}
            when 1 {nextRunTime = System.now().addMinutes(30);}
            when 2 {nextRunTime = System.now().addMinutes(60);}
            when else{
                return null;
            }
        }

        return nextRunTime;

    } 
}