public with sharing class GetTopFiveContactController {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getTopFiveContacts(){
        return [SELECT Id, Name, Phone, Email from Contact WITH USER_MODE LIMIT 5];
    }
}