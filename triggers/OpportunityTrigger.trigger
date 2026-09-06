trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

    //kill switch
    Trigger_Config__mdt config = Trigger_Config__mdt.getInstance('Opportunity');

    if(config!=null && !config.Is_Enabled__C){
        
        new OpportunityTriggerHandler().run();
    }
}