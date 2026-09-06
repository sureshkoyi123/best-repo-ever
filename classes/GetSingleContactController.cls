public with sharing class GetSingleContactController {
    @AuraEnabled(Cacheable=true)
    public static Contact getContact(){
        return [Select Id, Name from Contact WITH USER_MODE LIMIT 1];
    }
}