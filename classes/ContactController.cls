public with sharing class ContactController {
    @AuraEnabled(Cacheable=true)
    public static list<Contact> getContactList(Id accId) {
        return [ SELECT AccountId, Id, FirstName,LastName,Phone, Email 
        FROM Contact WHERE AccountId = :accId
        WITH USER_MODE

        ];

    }
    @AuraEnabled
public static void updateContacts(List<Contact> contacts) {
    try {
        // 1. Enforce FLS/CRUD Security       
        Security.stripInaccessible(AccessType.UPDATABLE, contacts);
        // 2. Perform the update
        update contacts;
    } catch (Exception e) {
        // 3. Throw an AuraHandledException so the LWC can read the exact error message
        throw new AuraHandledException('Failed to update contacts: ' + e.getMessage());
    }
}
}