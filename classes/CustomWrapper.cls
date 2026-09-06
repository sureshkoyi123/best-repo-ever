public with sharing class CustomWrapper {
    @AuraEnabled
    public Integer someInt {get; set;}
    @AuraEnabled
    public String someStr {get; set;}
    @AuraEnabled
    public List<String> someList{get;set;}
}