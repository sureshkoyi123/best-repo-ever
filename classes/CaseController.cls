public with sharing class CaseController {
    @AuraEnabled(Cacheable=true)
    public static list<Account> getNewCasesForAccounts() {
        return [Select Name, (Select Id, CaseNumber, status from cases where status='new') from Account Where Id IN(Select AccountId from Case where status='new')];
    }
}