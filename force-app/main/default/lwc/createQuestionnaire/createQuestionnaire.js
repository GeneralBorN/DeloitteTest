import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, createRecord } from 'lightning/uiRecordApi';
import QUESTIONNAIRE_OBJECT from '@salesforce/schema/Questionnaire__c';
import OWNER_ID_FIELD from '@salesforce/schema/Questionnaire__c.OwnerId';
import NAME_FIELD from '@salesforce/schema/User.Name';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class QuestionnaireCreator extends LightningElement {
    @api recordId; 
    @track questionnaires = [];
    @track showTable = false;
    @track ownerId; 
    @track ownerName; 
    @track showTellUsWhy = false;

    recommendOptions = [
        { label: 'Yes', value: 'Yes' },
        { label: 'No', value: 'No' }
    ];

    questionnaireRecord;

    connectedCallback() {
        this.questionnaireRecord = {
            apiName: QUESTIONNAIRE_OBJECT.objectApiName,
            fields: {
                Attending__c: true,
                Feedback__c: 'None',
                Name: 'Test Name',
            }
        };
        console.log('Initial questionnaireRecord:', this.questionnaireRecord);
    }

    @wire(getRecord, {
        recordId: '$recordId',
        fields: [OWNER_ID_FIELD],
    })
    recordHandler({ data, error }) {
        if (data) {
            this.ownerId = data.fields.OwnerId.value;
        } else if (error) {
            console.error('Error fetching Owner Id:', error);
        }
    }

    @wire(getRecord, {
        recordId: '$ownerId',
        fields: [NAME_FIELD],
    })
    ownerRecord({ data, error }) {
        if (data) {
            this.ownerName = data.fields.Name.value;
        } else if (error) {
            console.error('Error fetching owner record:', error);
        }
    }

    get title() {
        return this.ownerName ? `Hello ${this.ownerName}!` : 'Welcome!';
    }

    handleInputChange(event) {
        const eventTarget = event.target;
        if (!this.questionnaireRecord.fields) {
            this.questionnaireRecord.fields = {};
        }
        console.log('handleInputChange called');
        
        // Handle checkbox value separately
        if (eventTarget.type === 'checkbox') {
            this.questionnaireRecord.fields[eventTarget.name] = eventTarget.checked;
        } else {
            this.questionnaireRecord.fields[eventTarget.name] = eventTarget.value;

            // Specific logic for radio change
            if (eventTarget.type === 'radio' && eventTarget.name === 'Would_you_reccomend_this_Webinar__c') {
                this.showTellUsWhy = eventTarget.value === 'No';
            }
        }
    }

    submitAnswer() {
        this.isLoading = true;
        createRecord(this.questionnaireRecord)
            .then(result => {
                this.isLoading = false;
                this.handleSuccess(result);
                const newQuestionnaire = this.formatQuestionnaire(result);
                this.updateQuestionnaireList(newQuestionnaire);
            })
            .catch(error => {
                this.isLoading = false;
                this.handleError(error);
            });
    }

    formatQuestionnaire(record) {
        return {
            Id: record.id,
            fields: {
                Name: record.fields?.Name?.value || 'N/A',
                OwnerId: record.fields?.OwnerId?.value || 'N/A',
                Age__c: record.fields?.Age__c?.value || 'N/A',
                Attending__c: record.fields?.Attending__c?.value ? 'Yes' : 'No',
                Feedback__c: record.fields?.Feedback__c?.value || 'N/A',
                // Include any other fields needed
            }
        };
    }

    updateQuestionnaireList(newQuestionnaire) {
        if (!this.questionnaires) {
            this.questionnaires = [];
        }
        this.questionnaires.push(newQuestionnaire);
        console.log('Updated Questionnaires:', this.questionnaires);
    }

    handleSuccess(result) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Questionnaire created successfully!',
                variant: 'success',
            })
        );
    }

    handleError(error) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error creating Questionnaire',
                message: error.body?.message || 'Error completing the operation',
                variant: 'error',
            })
        );
    }

    handleShowTable() {
        this.showTable = true;
    }

    handleCloseTable() {
        this.showTable = false;
    }
}
