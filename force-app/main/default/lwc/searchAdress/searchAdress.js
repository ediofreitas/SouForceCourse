import { LightningElement, api } from 'lwc';
import beginSearchAddress from '@salesforce/apexContinuation/AccountAddressService.beginSearchAddress'
import { updateRecord } from 'lightning/uiRecordApi';
import Account_Id from '@salesforce/schema/Account.Id';
import Account_Street from '@salesforce/schema/Account.BillingStreet';
import Account_State from '@salesforce/schema/Account.BillingState';
import Account_City from '@salesforce/schema/Account.BillingCity';
import Account_Zip from '@salesforce/schema/Account.BillingPostalCode';
import Account_Country from '@salesforce/schema/Account.BillingCountry';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';


export default class SearchAdress extends LightningElement {

    @api recordId;

    zipCode;
    address;

    updateZipCode(event){
        this.zipCode = event.target.value;
    }

    async callAddressWs(){
        try {
            this.address = await beginSearchAddress({cep:this.zipCode});
            console.log(this.address);
        } catch (error) {
            console.error(error);
        }
    }

    async updateAddress(){
        try {
            const fields = {[Account_Id.fieldApiName] : this.recordId,
                            [Account_Street.fieldApiName] : this.address.logradouro,
                            [Account_State.fieldApiName] : this.address.uf,
                            [Account_City.fieldApiName] : this.address.localidade,
                            [Account_Zip.fieldApiName] : this.address.cep,
                            [Account_Country.fieldApiName] : 'Brasil'
                            }
            
            await updateRecord({fields : fields});

            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Address updated',
                    variant: 'success'
                })
            );
        } catch (error) {
            console.error(error);
        }
    }
}