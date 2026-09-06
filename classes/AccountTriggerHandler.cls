public class AccountTriggerHandler extends TriggerHandler{

protected override void afterUpdate(){

    //get changed record ids
    Set<Id> changedAccountIds = new Set<Id>();

    for( Account newAcc: (List<Account>)Trigger.new){
        Account oldAcc = (Account)Trigger.oldMap.get(newAcc.Id);
        if(newAcc.Name != oldAcc.Name){
            changedAccountIds.add(newAcc.Id);
        }
    }
    if(changedAccountIds.isEmpty()){
        return;
    }

    List<Contact> contacts = [Select Id, AccountId, Description from Contact WHERE AccountId IN :changedAccountIds];
    Map<Id,Account> newAccountsMap = (Map<Id,Account>)(Trigger.newMap);
    List<Contact> contactsToUpdate = new List<Contact>();
    for(Contact c: contacts){
        c.Description = c.Description + newAccountsMap.get(c.AccountId).Name;
        contactsToUpdate.add(c);
    }
    if(!contactsToUpdate.isEmpty()){
        update contactsToUpdate;
    }

}
    
}