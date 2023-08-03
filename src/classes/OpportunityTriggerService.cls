public with sharing class OpportunityTriggerService {

    public final static String OPPORTUNITY_STAGE_QUALIFICATION = 'Qualification';

    public static void handleTaskCreationAfterInsert(Map<Id, Opportunity> newOppMap) {
        List<Id> oppIds = new List<Id>();

        for (Opportunity opp : newOppMap.values()) {
            if (opp.StageName == OPPORTUNITY_STAGE_QUALIFICATION) {
                oppIds.add(opp.Id);
            }
        }

        TaskCreationService.createTasksForOpportunity(oppIds);
    }

    public static void handleTaskCreationAfterUpdate(Map<Id, Opportunity> newOppMap, Map<Id, Opportunity> oldOppMap) {
        List<Id> oppIds = new List<Id>();

        for (Opportunity opp : newOppMap.values()) {
            if (oldOppMap.get(opp.Id).StageName != OPPORTUNITY_STAGE_QUALIFICATION && opp.StageName == OPPORTUNITY_STAGE_QUALIFICATION) {
                oppIds.add(opp.Id);
            }
        }

        TaskCreationService.createTasksForOpportunity(oppIds);
    }
}