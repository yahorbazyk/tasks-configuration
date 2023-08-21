Here is the implementation of the Apex logic.

If you'd like, I can grant you access to the box for easier handling.

I have implemented the basic functionality based on the requirements, but of course it is possible to further customize everything even more dynamically.

1. Namely, we can add a list of fields to the Field set, which will be used to search for duplicates.
2. Add the ability to create tasks for each stage and customize them, but for this you will need to add a field on the task, which will qualify to which stage belongs to the task.
3. Add the ability to assign certain people to each task, for the solution will need to determine which field will be unique for the search, so as not to use hardcoded id.

I implemented the logic call from both the trigger and Flow. I also added buttons to call logic without waiting for trigger conditions. I have also used several ways to call this functionality, via Flow, LWC, Aura components.

The process itself is based on task configuration management via Custom Metadata Types. Where we can customize the data.
![CleanShot 2023-08-03 at 20 51 30](https://github.com/yahorbazyk/tasks-configuration/assets/135764285/35739c8a-1620-4b88-a0de-328ad12143af)
![CleanShot 2023-08-03 at 20 51 55](https://github.com/yahorbazyk/tasks-configuration/assets/135764285/20063e43-c097-4be6-bae7-06daa00f39a8)


It is also realized to run the logic through a trigger, and through Flow Trigger.
![CleanShot 2023-08-03 at 20 53 03](https://github.com/yahorbazyk/tasks-configuration/assets/135764285/cc22ff7e-8fec-4fc8-9f23-c63a27e5a50b)


Buttons are added to call the logic regardless of the trigger condition. In 3 variants - Flow, LWC, Aura - Action Buttons
![CleanShot 2023-08-03 at 20 53 26](https://github.com/yahorbazyk/tasks-configuration/assets/135764285/b8a08e61-67b7-444e-b5a1-66c0298792f3)
