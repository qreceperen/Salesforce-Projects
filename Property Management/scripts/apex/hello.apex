List<Property__c> properties = PrpertyServiceController.getAllProperties();

for(Property__c prop : properties){
    system.debug('Property ' + prop);
}