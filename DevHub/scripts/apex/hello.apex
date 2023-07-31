// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

// currencyAPI.getCurrencyData('USD', 'TRY', 500);
currencyAPI.Request request = new currencyAPI.Request();
request.currencyFrom = 'USD';
request.currencyTo = 'TRY';
request.amount = 500;

List<currencyAPI.Request> requests = new List<currencyAPI.Request>{request};
List<Decimal> results = currencyAPI.getCurrencyDataFlow(requests);
System.debug('Results: ' + results);