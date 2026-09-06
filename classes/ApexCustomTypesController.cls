public with sharing class ApexCustomTypesController {
    @AuraEnabled(Cacheable=true)
    public static String checkApexTypes(CustomWrapper wrapper) {
          String response =
            'You entered "' +
            wrapper.someStr +
            '" as String, and "' +
            wrapper.someInt +
            '" as Integer value. The list contained ' +
            wrapper.someList.size() +
            ' items.';
        return response;
        
    }
}