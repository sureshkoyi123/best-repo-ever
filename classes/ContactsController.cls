public with sharing class ContactsController {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContactList(){
        return [Select FirstName, LastName,Title,Email,Phone, Picture__c from Contact Limit 10];
    }
}