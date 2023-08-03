@IsTest
private class OpportunityTriggerServiceTest {

    @TestSetup
    static void setupTestData() {
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', StageName = 'Needs Analysis', CloseDate = Date.today());
        insert testOpp;
    }

    @IsTest
    static void taskCreationOnInsertWithQualificationTest() {
        Opportunity testOpp = [SELECT Id, Name, StageName FROM Opportunity LIMIT 1];
        testOpp.StageName = 'Qualification';
        update testOpp;

        Test.startTest();
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE WhatId = :testOpp.Id];
        Test.stopTest();

        Assert.areEqual(false, tasks.isEmpty(), 'Expected a task to be created for the opportunity');
    }

    @IsTest
    static void noTaskCreationOnInsertWithDifferentStageTest() {
        Opportunity testOpp = [SELECT Id, Name, StageName FROM Opportunity LIMIT 1];

        Test.startTest();
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE WhatId = :testOpp.Id];
        Test.stopTest();

        Assert.areEqual(0, tasks.size(), 'Expected no task to be created for the opportunity');
    }

    @IsTest
    static void taskCreationOnUpdateToQualificationTest() {
        Opportunity testOpp = [SELECT Id, Name, StageName FROM Opportunity LIMIT 1];
        testOpp.StageName = 'Qualification';
        update testOpp;

        Test.startTest();
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE WhatId = :testOpp.Id];
        Test.stopTest();

        Assert.areEqual(false, tasks.isEmpty(), 'Expected a task to be created after updating the opportunity to Qualification stage');
    }

    @IsTest
    static void noTaskCreationOnUpdateStageUnchangedTest() {
        Opportunity testOpp = [SELECT Id, Name, StageName FROM Opportunity LIMIT 1];
        testOpp.Name = 'Test Opportunity Updated';  // Update some other field, but keep stage unchanged.
        update testOpp;

        Test.startTest();
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE WhatId = :testOpp.Id];
        Test.stopTest();

        Assert.areEqual(0, tasks.size(), 'Expected no additional task to be created as the stage was unchanged');
    }

    @IsTest
    static void taskCreationForOpportunityWithQualificationStageOnInsertTest() {
        Opportunity testOppQualification = new Opportunity(Name = 'Test Opportunity Qualification', StageName = 'Qualification', CloseDate = Date.today());
        insert testOppQualification;

        Test.startTest();
        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE WhatId = :testOppQualification.Id];
        Test.stopTest();

        Assert.areEqual(false, tasks.isEmpty(), 'Expected a task to be created for the opportunity with Qualification stage upon insert.');
    }

    @IsTest
    static void testNoDuplicateTaskCreationWhenExistingTaskSubjectMatches() {
        Opportunity testOpp = [SELECT Id, Name, StageName FROM Opportunity LIMIT 1];

        Task testTask = new Task(Subject = 'Email', WhatId = testOpp.Id);
        insert testTask;

        // Update Opportunity to Qualification stage
        testOpp.StageName = 'Qualification';
        update testOpp;

        // Execute: Get all tasks related to the Opportunity after update
        Test.startTest();
        List<Task> tasksAfterUpdate = [SELECT Id, Subject, WhatId FROM Task WHERE WhatId = :testOpp.Id];
        Test.stopTest();

        // Assert: No additional tasks should be created as the task with the matching subject already exists
        Assert.areEqual(5, tasksAfterUpdate.size(), 'Expected no new tasks to be created as task with matching subject already exists.');
        Assert.areEqual(testTask.Subject, tasksAfterUpdate[0].Subject, 'Existing task subject should match the one after update.');
    }
}