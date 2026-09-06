public with sharing class OrderIntegrationQueueable implements Queueable, Database.AllowsCallouts{
    private Set<Id> orderIds;
    public OrderIntegrationQueueable(Set<Id> orderIds){

        this.orderIds = orderIds;

    }

    public void execute(QueueableContext qc){

        OrderIntegrationService.processSync(orderIds);

    }
}