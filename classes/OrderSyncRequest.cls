public with sharing class OrderSyncRequest {

    public List<OrderData> orders;
    public OrderSyncRequest(List<Order> orderRecords) {

        orders = new List<OrderData>();

        for(Order ord : orderRecords){
            orders.add(new OrderData(ord));
        }


    }

    public class OrderData{
        public String orderId;
        public String orderNumber;
        public String opportunityId;
        public String accountId;
        public Date effectiveDate;
        public String status;

        public List<OrderItemData> items;
        
        public OrderData(Order ord){
            this.orderId = ord.Id;
            this.orderNumber = ord.OrderNumber;
            this.accountId = ord.AccountId;
            this.opportunityId = ord.Source_Opportunity__c;
            this.effectiveDate = ord.EffectiveDate;
            this.status = ord.Status;

            items = new List<OrderItemData>();
            if (ord.OrderItems != null) {
            for(OrderItem item : ord.OrderItems){
                items.add(new OrderItemData(item));
            }
        }

        }
    }

    public class OrderItemData{
        public String productId;
        public Decimal quantity;
        public Decimal unitPrice;
        public String productName;


        public OrderItemData(OrderItem item){

            this.productId = item.PricebookEntry.Product2Id;
            this.productName = item.PricebookEntry.Product2.Name;
            this.quantity = item.Quantity;
            this.unitPrice = item.UnitPrice;
            
        }
    }
}