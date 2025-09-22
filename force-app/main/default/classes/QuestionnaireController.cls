public with sharing class QuestionnaireController {
    @AuraEnabled(cacheable=true)
    public static List<Questionnaire__c> getQuestionnaires() {
        try {
            return [SELECT Id, Name, Owner.Name, Age__c, Attending__c, Feedback__c FROM Questionnaire__c];
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving questionnaires: ' + e.getMessage());
        }
    }
}
