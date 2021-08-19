import { LightningElement } from 'lwc';

export default class TemplateTrueFalse extends LightningElement {

    connectedCallback() {
       this.data = [{name: 'Édio Freitas',
                     lastName: 'Brabo'},
                    {name: 'Programador'},
                    {name: 'LWC'}
        ]
    }

}