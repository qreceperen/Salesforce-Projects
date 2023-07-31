@isTest
private class CurrencyAPITest {
    @isTest static void testGetCurrencyData() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        // Act
        Decimal result = currencyAPI.getCurrencyData('USD', 'TRY', 100);
        
        // Assert
        System.assertEquals(2692.09, result);
    }
    @isTest static void testGetCurrencyDataFlow (){
        // Arrange
    Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
    
    // Create a list of Request objects to pass to the method
    List<currencyAPI.Request> requests = new List<currencyAPI.Request>();
    currencyAPI.Request req = new currencyAPI.Request();
    req.currencyFrom = 'USD';
    req.currencyTo = 'TRY';
    req.amount = 100;
    requests.add(req);

    // Act
    List<Decimal> results = currencyAPI.getCurrencyDataFlow(requests);

    // Assert
    // System.assertNotEquals(null, results);
    System.assertEquals(1, results.size());
    System.assertEquals(2692.09, results[0]);
    }
}
