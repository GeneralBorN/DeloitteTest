public class ContactTestDataFactory {

    // Create test Contacts with specified last names
    public static List<Contact> createTestContacts(List<String> lastNames) {
        List<Contact> contacts = new List<Contact>();
        for (String lastName : lastNames) {
            contacts.add(new Contact(FirstName = 'Test', LastName = lastName));
        }
        return contacts;
    }
}
