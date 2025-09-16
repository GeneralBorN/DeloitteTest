public class TestDataFactory {
    
    // Create test Account records
    public static List<Account> createTestAccounts(Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
        return accounts;
    }
    
    // Create test Opportunity records linked to Accounts
    public static List<Opportunity> createTestOpportunities(List<Account> accounts) {
        List<Opportunity> opportunities = new List<Opportunity>();
        for (Account acc : accounts) {
            opportunities.add(new Opportunity(Name = 'Test Opportunity', StageName = 'Prospecting', CloseDate = Date.today(), AccountId = acc.Id));
        }
        insert opportunities;
        return opportunities;
    }
}
