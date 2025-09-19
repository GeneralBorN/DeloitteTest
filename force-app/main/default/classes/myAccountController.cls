public with sharing class myAccountController {
    @AuraEnabled(cacheable=true)
    public static Account getRandomAccount() {
        List<Account> accounts = [SELECT Id, Name, Phone, Website FROM Account ORDER BY CreatedDate DESC];
        
        if (accounts.size() > 0) {
            Integer randomIndex = Math.mod(Integer.valueOf(Math.abs(DateTime.now().getTime())), accounts.size());
            Account randomAccount = accounts[randomIndex];
            System.debug('getRandomAccount called: ' + randomAccount);
            return randomAccount;
        }
        return null; // return null if no accounts are found
    }
}
