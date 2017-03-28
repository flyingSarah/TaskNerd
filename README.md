# TaskNerd
TaskNerd is a productivity application that categorizes tasks into daily, weekly, or monthly repeating tasks, one off tasks, or checklists.

#### What problem does this application solve?
I really love trying out all the different productivity apps I find people talking about on the internet. I've speant a lot of time transferring my system over to new apps to test them out -- something that mostly just ends up distracting me from actually being productive. After playing around with different systems over the years I have managed to identify a couple of favorites that seem to help me get things done (looking at you [Habitica]!) The problem is, I just can't seem to get away from typing out the main things I want to get done in a day in a plain text document. It's just so easy to use a plain text document for tasks that represent the goals of one single day.. I don't have to navigate a UI or be tempted to set up a bunch of other parameters (priority, due date, tags, etc.).

Now don't get me wrong, I love the fuller feature set an app provides. I love using Habitica to gamify my life and set up longer term goals and repeating habits - but I'd love to combine it all into one app, where I can quickly set up a bunch of simple tasks, but also have the option to get more detailed and use other features if I want to. I prefer to use something that has a minimalist appearance and usability, but that offers a deeper feature set for tasks you wish to put a little more planning into.

These are the ideas that drive the development of TaskNerd. Hopefully, it will be useful to myself and others once it's finished.

#### Daily, Weekly, and Monthly Tasks:
These views allow you to create tasks that automatically reset/repeat every day, week, or month.
##### Counter / Goal Numbers:
  - There are two numbers to the right of every repeating task.
  - The number to the left of the "/" represents the number of times you've checked off that task within the time frame (the "counter").
  - The number to the right of the "/" represents the ideal number of times you would like to check off the task within the time frame (the "goal").
  - Use Case Example: Perhaps you'd like to go for a morning run at least 5 times every week. You'd go to the "Weekly" tab, make a new task called "Morning Run", and go to the edit view for that task to set the goal to 5. If you check off the task 3 times, then "3/5" is displayed to the right of the task. This means you've done it 4 times out of the 5 times you were planning to do it.
  - The counter can move past the goal amount to allow you to go above and beyond your original ambition.
  - The counter will reset once a new day, week, or month begins.
  
#### One Off Tasks:
This tab lets you just create super simple tasks with a label and a check box. You can give them a priority, difficulty rating, and due date if you want but they work just as well without all the bells and whistles.

#### Checklists:
This is a special tab that lets you work towards multi-step goals. Here you just create a label for your task, then in edit mode you can add sub-tasks to it. As you check off your sub-tasks, you can exit edit view and see your progress displayed in the background of the task label. This kind of "progress bar" type visualization tends to be really motivating for me. I also like that the main view just simply shows the task and your progress to keep it simple for a quick peek at how you're doing.

#### Priority and Difficulty Ratings:
You can give tasks in any of the views a priority and difficulty rating if you'd like.

  - Priority has five settings (highest, high, medium, low, lowest).
  - Difficulty has three settings (easy, medium, hard).
  - You can change these in the task edit views and they will auto-sort (first by priority, then by difficulty). So your task order will look like this:
    - highest priority / easy tasks
    - highest priority / medium difficulty tasks
    - highest priority / hard tasks
    - high priority / easy tasks
    - etc.
  - These are indicated subtly in the regular list view by a colorful shape to the left of the task.
    - Priority is indicated by the color of the shape (red is highest priority, blue is lowest).
	- Difficulty is indicated by which shape it is. Easy tasks get a circle, medium tasks get a square, and hard tasks get a diamond.

[//]: # (reference links below...)
   [habitica]: <https://habitica.com>

