trigger UpdateWebinarParticipantsTrigger on Webinar_Member__c (after insert, after update, after delete) {
    Set<Id> webinarIds = new Set<Id>();
    
    if (Trigger.isDelete) {
        for (Webinar_Member__c wm : Trigger.old) {
            webinarIds.add(wm.Webinar__c);
        }
    } else {
        for (Webinar_Member__c wm : Trigger.new) {
            webinarIds.add(wm.Webinar__c);
        }
        
        
        if (Trigger.isUpdate) {
            //If its an update, then we need to check if the webinar has changed
            //If it has, then we need to add both the old and new webinar IDs to the set
            for (Integer i = 0; i < Trigger.new.size(); i++) {
                Webinar_Member__c newMember = Trigger.new[i];
                Webinar_Member__c oldMember = Trigger.old[i];
                
                if (newMember.Webinar__c != oldMember.Webinar__c) {
                    webinarIds.add(oldMember.Webinar__c); // Add old webinar ID
                    webinarIds.add(newMember.Webinar__c); // Add new webinar ID
                }
            }
        }
    }

    List<Webinar__c> webinarsToCheck = [SELECT Id FROM Webinar__c WHERE Id IN :webinarIds];

    List<AggregateResult> participantCounts = [
        SELECT Webinar__c, COUNT(Id) participantCount 
        FROM Webinar_Member__c 
        WHERE Webinar__c IN :webinarIds 
        GROUP BY Webinar__c
    ];

    for (Webinar__c w : webinarsToCheck) {
        Integer participantCount = 0;
        
        for (AggregateResult ar : participantCounts) {
            if ((Id) ar.get('Webinar__c') == w.Id) {
                participantCount = ((Decimal) ar.get('participantCount')).intValue();
                //participantCount = (Integer) ar.get('participantCount');
                break;
            }
        }
        
        w.Number_Of_Participants__c = participantCount;
    }
    
    update webinarsToCheck;
}
