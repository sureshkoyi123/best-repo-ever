import { LightningElement, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import { notifyRecordUpdateAvailable } from "lightning/uiRecordApi";

// Import Apex Methods
import getContactList from '@salesforce/apex/ContactController.getContactList';
import updateContacts from "@salesforce/apex/ContactController.updateContacts";

// Import Schema Fields
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LASTNAME_FIELD from '@salesforce/schema/Contact.LastName';
import TITLE_FIELD from "@salesforce/schema/Contact.Title";
import PHONE_FIELD from "@salesforce/schema/Contact.Phone";
import EMAIL_FIELD from "@salesforce/schema/Contact.Email";

const COLS = [
    { label: "First Name", fieldName: FIRSTNAME_FIELD.fieldApiName, editable: true },
    { label: "Last Name", fieldName: LASTNAME_FIELD.fieldApiName, editable: true },
    { label: "Title", fieldName: TITLE_FIELD.fieldApiName, editable: true },
    { label: "Phone", fieldName: PHONE_FIELD.fieldApiName, type: "phone", editable: true },
    { label: "Email", fieldName: EMAIL_FIELD.fieldApiName, type: "email", editable: true }
];

export default class ContactsDataTable extends LightningElement {
    @api recordId;
    columns = COLS;
    draftValues = [];
    
    // Provisioned property to hold the wire result for refreshApex
    wiredContactsResult={data: null, error: null};

    @wire(getContactList, { accId: "$recordId" })
    wiredContacts(result) {
        this.wiredContactsResult = result; // Keep a reference for refreshApex
    }
    
    async handleSave(event) {
        const updatedFields = event.detail.draftValues;

        try {
            // 1. Pass data to Apex (Using the correct 'contacts' parameter matching the optimized Apex)
            await updateContacts({ contacts: updatedFields });

            // 2. Clear draft values immediately to remove the "Save/Cancel" bottom bar in UI
            this.draftValues = [];

            // 3. Show Success Toast
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contacts updated successfully.',
                    variant: 'success'
                })
            );

            // 4. Notify LDS that records changed (notifies other components on the page)
            const recordIds = updatedFields.map(row => ({ recordId: row.Id }));
            await notifyRecordUpdateAvailable(recordIds);

            // 5. Refresh the local datatable data
            await refreshApex(this.wiredContactsResult);

        } catch (error) {
            // Safely parse the error message regardless of structure
            const errorMessage = error.body?.message || error.message || 'Unknown error';
            
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating records',
                    message: errorMessage,
                    variant: 'error'
                })
            );
        }
    }
}