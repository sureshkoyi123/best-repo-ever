public with sharing class UpdateAccountNameController {
    
    @AuraEnabled
    public static void updateAccountName( Id recordId){
        if(recordId==null){
            throw new AuraHandledException('Record Id is required.');
        }
        Account a = [Select Id, Name from Account WHERE Id = :recordId WITH USER_MODE LIMIT 1];
        a.Name = a.Name + ' '  + 'Updated';
        update a;

    }
}