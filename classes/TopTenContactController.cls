public with sharing class TopTenContactController {
@AuraEnabled(Cacheable=true)
    public static List<Contact> getTopTenContacts(){
        return [SELECT Id, Name, Phone, Email from Contact WITH USER_MODE LIMIT 10];
    }
    
}