trigger MyWebinarMembersTrigger on Webinar_Member__c (before insert, before update) {
    List<Webinar_Member__c> ExistingWebMembers=new List<Webinar_Member__c>();
    for(Webinar_Member__c wm : Trigger.New) {
        for(Webinar_Member__c wmExisting : ExistingWebMembers){
            if(wmExisting.Name == wm.Name && wmExisting.Webinar__c	==wm.Webinar__c	){
                wm.addError('This is an error: Duplicates!');
            }
        }
    }
}