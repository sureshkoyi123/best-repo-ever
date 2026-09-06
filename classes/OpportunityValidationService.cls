public with sharing class OpportunityValidationService {
   
    public static void validateClosedWon(List<Opportunity> newOpps, Map<Id,Opportunity> oldMap){

        for(Opportunity opp : newOpps){
            Opportunity oldOpp = oldMap.get(opp.Id);

            if(oldOpp.StageName != OpportunityConstants.STAGE_CLOSED_WON && opp.StageName==OpportunityConstants.STAGE_CLOSED_WON){
                if(opp.CloseDate == null){
                    opp.CloseDate.addError('Close Date is required.');
                }
                
                if(opp.Amount == null || opp.Amount <= 0){
                    opp.Amount.addError('Amount must be greater than zero.');
                } 
                
            }
        }
    }


}