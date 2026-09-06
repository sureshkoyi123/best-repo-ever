public with sharing class GetContactController {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getContacts(String searchKey){
        if(String.isBlank(searchKey)){
        return new List<Contact>();
        }
        searchKey = '%' + searchKey + '%';
        return [SELECT Id, Name from Contact WHERE Name LIKE :searchKey WITH USER_MODE LIMIT 5];
        
        
    }
}