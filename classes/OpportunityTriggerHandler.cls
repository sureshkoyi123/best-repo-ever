public with sharing class OpportunityTriggerHandler {
    
    public void run(){
        switch on Trigger.operationType{
            when BEFORE_INSERT{beforeInsert();}
            when BEFORE_UPDATE{beforeUpdate();}
            when BEFORE_DELETE{beforeDelete();}
            when AFTER_INSERT{afterInsert();}
            when AFTER_UPDATE{afterUpdate();}
            when AFTER_DELETE{afterDelete();}
            when AFTER_UNDELETE{afterUndelete();}
        }        

    }
    private void beforeInsert(){
         OpportunityBusinessService.processBeforeInsert((List<Opportunity>) Trigger.new);   
    }

    private void beforeUpdate(){
        OpportunityBusinessService.processBeforeUpdate((List<Opportunity>) Trigger.new, (Map<Id,Opportunity>) Trigger.oldMap);
       
    }

    private void beforeDelete(){
        OpportunityBusinessService.processBeforeDelete((List<Opportunity>) Trigger.old);

    }
    private void afterInsert(){
        OpportunityBusinessService.processAfterInsert((List<Opportunity>) Trigger.new);

    }
    private void afterUpdate(){
        OpportunityBusinessService.processAfterUpdate((List<Opportunity>) Trigger.new,(Map<Id,Opportunity>) Trigger.oldMap);

    }
    private void afterDelete(){
        OpportunityBusinessService.processAfterDelete((List<Opportunity>) Trigger.old);
    }
    private void afterUndelete(){
        OpportunityBusinessService.processAfterUndelete((List<Opportunity>) Trigger.new);

    }

}