public class OpportunityTriggerHandler extends TriggerHandler {

    private final Map<Id, Opportunity> newOppMap;
    private final Map<Id, Opportunity> oldOppMap;

    public OpportunityTriggerHandler() {
        this.newOppMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.oldOppMap = Trigger.isUpdate ? (Map<Id, Opportunity>) Trigger.oldMap : null;
    }

    public override void afterInsert() {
        OpportunityTriggerService.handleTaskCreationAfterInsert(newOppMap);
    }

    public override void afterUpdate() {
        OpportunityTriggerService.handleTaskCreationAfterUpdate(newOppMap, oldOppMap);
    }
}