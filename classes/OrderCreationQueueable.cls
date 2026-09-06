public with sharing class OrderCreationQueueable implements Queueable{
    private Set<Id> opportunityIds;
    public OrderCreationQueueable(Set<Id> opportunityIds) {

        this.opportunityIds = opportunityIds;

    }

    public void execute(QueueableContext qc){

        System.debug('Before calling create order in side queue execute method: ' + opportunityIds);
        RelatedRecordService.createOrders(opportunityIds);

    }
}