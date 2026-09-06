public with sharing class TopTenOpportunityController {
    @AuraEnabled(Cacheable=true)
 public static List<Opportunity> getTopTenOpps(Id recordId){
    return [SELECT Id, Name, Amount, StageName from Opportunity WHERE AccountId = :recordId WITH user_mode ORDER BY Amount DESC  LIMIT 10 ];
 }
}