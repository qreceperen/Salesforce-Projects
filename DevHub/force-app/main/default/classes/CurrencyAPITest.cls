@isTest
private class CurrencyAPITest {
    @isTest static void testGetCurrencyData() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        // Act
        Decimal result = currencyAPI.getCurrencyData('USD', 'TRY', 100);
        
        // Assert
        System.assertEquals(2692.09, result, 0.01);
    }
    
    @isTest static void testGetCurrencyNull() {
        // Arrange
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockImpl());
        
        // Act
        Decimal result = currencyAPI.getCurrencyData('USDA', 'TRY', 100);
        
        // Assert
        System.assertEquals(NULL, result);
    }

}
