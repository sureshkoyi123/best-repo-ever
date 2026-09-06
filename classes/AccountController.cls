// AccountController.cls
public with sharing class AccountController {
  @AuraEnabled(Cacheable=true)
    public static list<Account> getAccountsWithContacts(){
        return [SELECT Id, Name, Industry, AnnualRevenue, (SELECT Id, FirstName, LastName, Email FROM Contacts) FROM Account WITH USER_MODE LIMIT 10];
    }
}