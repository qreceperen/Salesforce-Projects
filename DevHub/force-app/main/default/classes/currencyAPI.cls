public with sharing class currencyAPI {
  // This is the wrapper class to hold values coming from Flow. Values are taken as a list in getCurrencyData and kept in here.
  public class Request{
    @InvocableVariable
    public String currencyFrom;
    @InvocableVariable
    public String currencyTo;
    @InvocableVariable
    public Integer amount;

  }
  @InvocableMethod(label='Get Data Through getCurrencyDataFlow' description='Returns the currency conversion result.')
  public static List<Decimal> getCurrencyDataFlow (List<Request> requests){
    List<Decimal> results = new List<Decimal>();
    for (Request req : requests){
      Decimal result =  getCurrencyData(req.currencyFrom,req.currencyTo,req.amount);
      results.add(result);
    }
    return results;
  }


  public static Double getCurrencyData (String currencyFrom, String currencyTo, Integer amount) {
    API_Configuration__mdt apiLayer = API_Configuration__mdt.getInstance('apiLayerCurrency');
    String endPoint = apiLayer.API_Endpoint__c + '?to=' + currencyTo + '&from=' + currencyFrom + '&amount=' + amount;
    
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(endPoint);
    request.setMethod('GET');
    request.setHeader('apikey', apiLayer.API_Key__c);
    HttpResponse response = http.send(request);
    
    if (response.getStatusCode() == 200) {
      String jsonResponse = response.getBody();
      jsonResponse = jsonResponse.replace('"from"', '"currencyFrom"');
      currencyData data = (currencyData) JSON.deserialize (jsonResponse,currencyData.class);
      Decimal result =data.result;
      result = result.setScale(2);
      return result;
    } else {
      system.debug(
        'HTTP request failed with status code ' + response.getStatusCode());
        return null;
      }
    }
}