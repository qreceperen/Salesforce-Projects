public with sharing class currencyAPI {

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
      system.debug(result);
      return result;
    } else {
      system.debug(
        'HTTP request failed with status code ' + response.getStatusCode());
        return null;
    }
  }
}