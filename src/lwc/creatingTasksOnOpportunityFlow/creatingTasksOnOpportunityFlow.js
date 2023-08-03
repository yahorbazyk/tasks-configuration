import {LightningElement, api} from 'lwc';
import {CloseActionScreenEvent} from 'lightning/actions';
import {NavigationMixin} from 'lightning/navigation';
import createTasksForOpportunity from '@salesforce/apex/TaskCreationService.createTasksForOpportunityLWC';


export default class CreatingTasksOnOpportunityFlow extends NavigationMixin(LightningElement) {
    @api recordId;

    connectedCallback() {
        setTimeout(() => {
            if (this.recordId) {
                createTasksForOpportunity({oppIds: [this.recordId]})
                    .then(result => {
                        this.closeAction();
                    })
                    .catch(error => {
                        console.error('Error creating tasks:', error);
                    });
            }
        }, 5);
    }

    closeAction() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleClick(event) {
        if (this.recordId) {
            createTasksForOpportunity({oppIds: [this.recordId]})
                .then(result => {
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: this.recordId,
                            actionName: 'view'
                        },
                    });
                })
                .catch(error => {
                    console.error('Error creating tasks:', error);
                });
        }
    }
}