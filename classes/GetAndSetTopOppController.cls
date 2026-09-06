public with sharing class GetAndSetTopOppController {
    
    @AuraEnabled(Cacheable=true)
    public static List<Opportunity> getOppMoreThanAmount(Decimal amount){
        return [Select Id, Name, Amount, CloseDate, StageName from Opportunity WHERE Amount > :amount LIMIT 5];
    }

    @AuraEnabled
    public static void updateStage(Decimal amount, String stageName){

        List<Opportunity> opps = [Select Id from Opportunity WHERE amount > :amount LIMIT 5];
        
        for(Opportunity opp : opps){
            opp.StageName = stageName;
            
        }

        if(!opps.isEmpty()){
            update opps;
        }

    }
}