@RestResource(urlMapping='/v1/AccountSync/*')
global with sharing class AccountSyncREST {

    // ==========================================
    // GET: Retrieve Account by ID
    // ==========================================
    @HttpGet
    global static AccountResponse getAccountById() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        // Guard Clause: Validate ID presence and format
        if (String.isBlank(accId) || accId == 'AccountSync' || !(accId instanceof Id)) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'Valid Account Id is required in the URL path.');
        }

        try {
            Account acc = [
                SELECT Id, Name, Industry, Phone 
                FROM Account 
                WHERE Id = :accId 
                WITH USER_MODE 
                LIMIT 1
            ];
            res.statusCode = 200;
            return new AccountResponse('Success', 'Account found', acc);
        } catch (QueryException qe) {
            res.statusCode = 404;
            return new AccountResponse('Error', 'Account record not found.');
        } catch (Exception ex) {
            res.statusCode = 500;
            return new AccountResponse('Error', 'System Error: ' + ex.getMessage());
        }
    }

    // ==========================================
    // POST: Create New Account
    // ==========================================
    @HttpPost
    global static AccountResponse createAccount(String name, String industry) {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        if (String.isBlank(name)) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'Account Name is required.');
        }

        try {
            Account acc = new Account(Name = name, Industry = industry);

            // Enforce Field-Level Security for creation
            SObjectAccessDecision decision = Security.stripInaccessible(AccessType.Creatable, new List<Account>{acc});
            insert decision.getRecords();

            res.statusCode = 201;
            return new AccountResponse('Success', 'Account created successfully', (Account) decision.getRecords()[0]);
        } catch (DmlException dmlEx) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'DML Exception: ' + dmlEx.getDmlMessage(0));
        } catch (Exception ex) {
            res.statusCode = 500;
            return new AccountResponse('Error', 'System Error: ' + ex.getMessage());
        }
    }

    // ==========================================
    // PATCH: Partial Account Update
    // ==========================================
    @HttpPatch
    global static AccountResponse updateAccountDetails() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        // Guard Clause 1: Validate ID
        if (String.isBlank(accId) || accId == 'AccountSync' || !(accId instanceof Id)) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'Valid Account Id is required in the URL path.');
        }

        // Guard Clause 2: Ensure Body is present
        if (req.requestBody == null || String.isBlank(req.requestBody.toString())) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'Request body is missing.');
        }

        try {
            Account accToUpdate = new Account(Id = accId);
            Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());

            // Dynamic field mapping using sObject.put()
            for (String key : params.keySet()) {
                String fieldName = key.trim();
                // Match case-insensitive keys
                if (fieldName.equalsIgnoreCase('name')) {
                    accToUpdate.put('Name', (String) params.get(key));
                } else if (fieldName.equalsIgnoreCase('industry')) {
                    accToUpdate.put('Industry', (String) params.get(key));
                } else if (fieldName.equalsIgnoreCase('phone')) {
                    accToUpdate.put('Phone', (String) params.get(key));
                }
            }

            // Enforce USER_MODE DML
            update as user accToUpdate;

            // Query updated record state
            Account updatedAcc = [
                SELECT Id, Name, Industry, Phone 
                FROM Account 
                WHERE Id = :accId 
                WITH USER_MODE 
                LIMIT 1
            ];

            res.statusCode = 200;
            return new AccountResponse('Success', 'Account updated successfully', updatedAcc);

        } catch (DmlException dmlEx) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'DML Exception: ' + dmlEx.getDmlMessage(0));
        } catch (Exception ex) {
            res.statusCode = 500;
            return new AccountResponse('Error', 'System Error: ' + ex.getMessage());
        }
    }
// ==========================================
// PUT: Upsert / Full Replacement of Account
// ==========================================

// ==========================================
// PUT: Idempotent Upsert using External ID
// ==========================================
@HttpPut
global static AccountResponse upsertAccount() {
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;

    // Guard Clause 1: Request Body Validation
    if (req.requestBody == null || String.isBlank(req.requestBody.toString())) {
        res.statusCode = 400;
        return new AccountResponse('Error', 'Request body is required for PUT operation.');
    }

    // Guard Clause 2: Payload Size Limit Guard (1MB)
    if (req.requestBody.size() > 1048576) {
        res.statusCode = 413;
        return new AccountResponse('Error', 'Payload exceeds maximum limit of 1MB.');
    }

    try {
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
        String extId = (String) params.get('externalId');
        String accName = (String) params.get('name');
        String industry = (String) params.get('industry');

        // Guard Clause 3: Mandatory External ID & Name Check
        if (String.isBlank(extId)) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'External ID (externalId) is required for idempotent upsert.');
        }
        if (String.isBlank(accName)) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'Account Name is required for upsert operation.');
        }

        // Check pre-existence to accurately assign 200 vs 201 HTTP Status Code
        List<Account> existingAccs = [
            SELECT Id 
            FROM Account 
            WHERE Org_A_Account_Number__c = :extId 
            WITH USER_MODE 
            LIMIT 1
        ]; 
       Boolean isUpdate = !existingAccs.isEmpty();

        Account acc = new Account();
        acc.Org_A_Account_Number__c = extId; // External ID field mapping
        acc.Name = accName;
        acc.Industry = industry;        

        // Idempotent Upsert in USER_MODE using the SObjectField token
        upsert as user acc Account.Fields.Org_A_Account_Number__c;

        // Set HTTP Status Code (200 OK for update, 201 Created for new insert)
        res.statusCode = isUpdate ? 200 : 201;
        return new AccountResponse('Success', 'Account successfully saved.', acc.Id);

    } catch (DmlException dmlEx) {
        res.statusCode = 400;
        return new AccountResponse('Error', 'DML Exception: ' + dmlEx.getDmlMessage(0));

    } catch (Exception ex) {
        res.statusCode = 500;
        return new AccountResponse('Error', 'System Error: ' + ex.getMessage());
    }
}

    // ==========================================
    // DELETE: Delete Account by ID
    // ==========================================
    @HttpDelete
    global static AccountResponse deleteAccountById() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String accId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

        // Guard Clause: Validate ID presence and format
        if (String.isBlank(accId) || accId == 'AccountSync' || !(accId instanceof Id)) {
            res.statusCode = 400;
            return new AccountResponse('Error', 'Valid Account Id is required in the URL path.');
        }

        try {
            Account acc = [
                SELECT Id 
                FROM Account 
                WHERE Id = :accId 
                WITH USER_MODE 
                LIMIT 1
            ];
            delete as user acc;
            res.statusCode = 200;
            return new AccountResponse('Success', 'Account is deleted');
        } catch (QueryException qe) {
            res.statusCode = 404;
            return new AccountResponse('Error', 'Account record not found.');
        }catch (DmlException dmlEx) {
        // Catches delete restriction errors (e.g., related records, validation rules)
        res.statusCode = 400;
        return new AccountResponse('Error', 'DML Exception: ' + dmlEx.getDmlMessage(0));

    }
        catch (Exception ex) {
            res.statusCode = 500;
            return new AccountResponse('Error', 'System Error: ' + ex.getMessage());
        }
    }


    // ==========================================
    // Inner Response Wrapper (DTO)
    // ==========================================
    global class AccountResponse {
        public String status;
        public String message;
        public String recordId;
        public Account record;


        // Required no-arg constructor for deserialization in calling orgs
        public AccountResponse() {}

        public AccountResponse(String status, String message, Account record) {
            this.status = status;
            this.message = message;
            this.record = record;
        }

        public AccountResponse(String status, String message) {
            this.status = status;
            this.message = message;
        }
            public AccountResponse(String status, String message, String recordId) {
            this.status = status;
            this.message = message;
            this.recordId = recordId;
        }
    }
}