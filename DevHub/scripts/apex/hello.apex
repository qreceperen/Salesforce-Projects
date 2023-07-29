// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// currencyAPI.getCurrencyData('USD', 'TRY', 300);

API_Configuration__mdt apiLayer = API_Configuration__mdt.getInstance(
  'apiLayerCurrency'
);
string endPoint = apiLayer.API_Endpoint__c;
string apiKey = apiLayer.API_Key__c;
