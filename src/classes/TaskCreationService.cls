public with sharing class TaskCreationService {

    @InvocableMethod
    public static void createTasksForOpportunity(List<Id> oppIds) {
        if (oppIds == null || oppIds.isEmpty() || String.valueOf(oppIds).contains('null')) {
            System.debug('The input parameters are empty.');
            return;
        }

        Map<Id, Set<String>> existingTaskSubjects = getExistingTaskSubjects(oppIds);
        List<Task> tasksToInsert = prepareTasksToInsert(oppIds, existingTaskSubjects);

        insertTasks(tasksToInsert);
    }

    @AuraEnabled
    public static void createTasksForOpportunityLWC(List<Id> oppIds) {
        createTasksForOpportunity(oppIds);
    }

    private static Map<Id, Set<String>> getExistingTaskSubjects(List<Id> oppIds) {
        Map<Id, Set<String>> oppIdToExistingTaskSubjects = new Map<Id, Set<String>>();

        for (Task existingTask : [SELECT Id, Subject, WhatId FROM Task WHERE WhatId IN :oppIds]) {
            if (!oppIdToExistingTaskSubjects.containsKey(existingTask.WhatId)) {
                oppIdToExistingTaskSubjects.put(existingTask.WhatId, new Set<String>());
            }

            oppIdToExistingTaskSubjects.get(existingTask.WhatId).add(existingTask.Subject);
        }

        return oppIdToExistingTaskSubjects;
    }

    private static List<Task> prepareTasksToInsert(List<Id> oppIds, Map<Id, Set<String>> existingTaskSubjects) {
        List<Task> tasksToInsert = new List<Task>();
        List<Task_Configuration__mdt> taskConfigurations = Task_Configuration__mdt.getAll().values();

        for (Id oppId : oppIds) {
            for (Task_Configuration__mdt taskConfiguration : taskConfigurations) {
                if (shouldAddTask(oppId, taskConfiguration, existingTaskSubjects)) {
                    tasksToInsert.add(createNewTask(oppId, taskConfiguration));
                }
            }
        }

        return tasksToInsert;
    }

    private static Boolean shouldAddTask(Id oppId, Task_Configuration__mdt taskConfiguration, Map<Id, Set<String>> existingTaskSubjects) {
        return !existingTaskSubjects.containsKey(oppId) || !existingTaskSubjects.get(oppId).contains(taskConfiguration.Subject__c);
    }

    private static Task createNewTask(Id oppId, Task_Configuration__mdt taskConfiguration) {
        return new Task(
                WhatId = oppId,
                Subject = taskConfiguration.Subject__c,
                ActivityDate = taskConfiguration.Due_Date__c,
                Priority = taskConfiguration.Priority__c,
                Status = taskConfiguration.Status__c,
                Type = taskConfiguration.Type__c
        );
    }

    private static void insertTasks(List<Task> tasksToInsert) {
        if (!tasksToInsert.isEmpty()) {
            try {
                insert tasksToInsert;
            } catch (DmlException e) {
                System.debug('Error inserting tasks for opportunities: ' + e.getMessage());
            }
        }
    }
}