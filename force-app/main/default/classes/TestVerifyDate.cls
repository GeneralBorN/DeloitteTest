@isTest
private class TestVerifyDate {
    @isTest
    static void CheckDateTest() {
        Date date1 = Date.newInstance(2023, 1, 1);
        Date date2 = Date.newInstance(2023, 1, 15);
        Date result = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(date2, result);
    }

    @isTest
    static void CheckDateTest2() {
        Date date1 = Date.newInstance(2023, 1, 1);
        Date date2 = Date.newInstance(2023, 2, 15);
        Date expectedDate = Date.newInstance(2023, 1, 31);
        Date result = VerifyDate.CheckDates(date1, date2);
        System.assertEquals(expectedDate, result);
    }
}
