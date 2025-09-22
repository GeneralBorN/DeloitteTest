import { LightningElement, wire, track } from 'lwc';
import getQuestionnaires from '@salesforce/apex/QuestionnaireController.getQuestionnaires';

export default class QuestionnaireTable extends LightningElement {
    @track questionnaires = [];
    isLoading = false;
    error;

    // Fetch questionnaires using Apex
    @wire(getQuestionnaires)
    wiredQuestionnaires({ error, data }) {
        if (data) {
            this.questionnaires = data.map(q => ({
                OwnerName: q.Owner.Name,
                Name: q.Name || 'N/A',
                OwnerId: q.OwnerId || 'N/A',
                Age: q.Age__c != null ? q.Age__c : 'N/A',
                Attending: q.Attending__c ? 'Yes' : 'No',
                Feedback: q.Feedback__c || 'N/A'
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.questionnaires = [];
        }
    }

    get isDataLoaded() {
        return !this.isLoading && this.questionnaires.length > 0;
    }
}
