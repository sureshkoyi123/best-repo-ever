// accountsTreegrid.js
// accountsTreegrid.js
import { LightningElement, track, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getAccountsWithContacts from "@salesforce/apex/AccountController.getAccountsWithContacts";

export default class AccountsTreegridCustomProps extends NavigationMixin(LightningElement) {
  accounts;
  error;

  @wire(getAccountsWithContacts)
  wiredAccounts({ error, data }) {
    if (data) {
      this.accounts = data.map((account) => ({
        ...account,
        _children: account.Contacts,
      }));
    } else if (error) {
      this.error = error;
      this.accounts = undefined;
    }
  }
  constructor() {
    super();
    this.columns = [
      {
        type: "text",
        fieldName: "Name",
        label: "Account Name",
      },
      {
        type: "customName",
        label: "Industry",
        typeAttributes: {
          industryName: { fieldName: "Industry" },
        },
      },
      {
        type: "customNumber",
        fieldName: "AnnualRevenue",
        label: "Annual Revenue",
      },
      {
        type: "text",
        fieldName: "FirstName",
        label: "First Name",
      },
      {
        type: "text",
        fieldName: "LastName",
        label: "Last Name",
      },
      {
        type: "email",
        fieldName: "Email",
        label: "Contact Email",
      },

      {
        type: "button-icon",
        typeAttributes: { iconName: "utility:edit", name: "edit", size: "x-small" },
      },
    ];
  }

  handleRowAction(event) {
    if (event.detail.action.name === "edit") {
      this[NavigationMixin.Navigate]({
        type: "standard__recordPage",
        attributes: {
          recordId: event.detail.row.Id,
          objectApiName: "Account",
          actionName: "edit",
        },
      });
    }
  }
}