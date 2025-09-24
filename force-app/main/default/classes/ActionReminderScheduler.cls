global class ActionReminderScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        //Date tomorrow = Date.today().addDays(1);

        // Query EmployeeActions where related Action start date = tomorrow
        List<EmployeeAction__c> actionsStartingTomorrow = [
            SELECT Id, Reference_to_Employee__r.Mail__c, Reference_to_Employee__r.First_Name__c, Reference_to_Action__r.Name
            FROM EmployeeAction__c
            WHERE Reference_to_Action__r.Start_Date__c = tomorrow
        ];

        // Prepare list of emails to send
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (EmployeeAction__c ea : actionsStartingTomorrow) {
            if (ea.Reference_to_Employee__r.Mail__c != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new String[] { ea.Reference_to_Employee__r.Mail__c });
                mail.setSubject('Reminder: Upcoming Action Tomorrow');
                mail.setPlainTextBody(
                    'Hi ' + ea.Reference_to_Employee__r.First_Name__c + ',\n\n' +
                    'This is a reminder that you are participating in "' + ea.Reference_to_Action__r.Name + '" which starts tomorrow.\n' +
                    'Please be ready to participate!\n\n' +
                    'Best regards,\nYour Team'
                );
                emails.add(mail);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}
