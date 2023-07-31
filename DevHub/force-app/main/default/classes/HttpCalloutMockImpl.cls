@isTest
global class HttpCalloutMockImpl implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type','application/json');

        if(req.getEndpoint().contains('currencyFrom=USDA')){
            res.setBody('{"info": {"quote": null,"timestamp": 1690595464},"query": {"amount": 100,"currencyFrom": "USDA","to": "TRY"},"success": false}');
        }else {
            res.setBody('{"info": {"quote": 26.920904,"timestamp": 1690595464},"query": {"amount": 100,"currencyFrom": "USD","to": "TRY"},"result": 2692.0904,"success": true}');
        }
        res.setStatusCode(200);
        return res;
    }
}
