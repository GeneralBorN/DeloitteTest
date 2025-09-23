public with sharing class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numberOfContacts, String commonLastName) {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < numberOfContacts; i++) {
            contacts.add(new Contact(LastName = commonLastName, FirstName = 'Test ' + i));
        }
        return contacts;
    }
}
