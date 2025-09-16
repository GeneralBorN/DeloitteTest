trigger RestrictContactByName on Contact (before insert, before update) {
    // Prevent insertion or update of Contacts with a forbidden last name
    @TestVisible
    private final String INVALID_NAME = 'INVALIDNAME';
    
    for (Contact c : Trigger.New) {
        if (c.LastName != null && c.LastName.equalsIgnoreCase(INVALID_NAME)) {
            c.addError('The Last Name "' + c.LastName + '" is not allowed.');
        }
    }
}