# TaskNerd
TaskNerd is a productivity application that allows you to set up tasks using basic categorizations: daily, weekly, and monthly repeating tasks; one off tasks; and checklists.

### What problem does this application solve?
I really love trying out all of the different productivity apps I find people talking about on the internet. It's actually ridiculous how much time I've spent transferring my system over to new apps to test them out - honestly, this mostly just ends up distracting me from actually being productive. After playing around with different systems over the years, I have managed to identify a couple of favorites that seem to help me get things done (looking at you [Habitica], and you [Trello]!) The problem is, I just can't seem to get away from making quick to-do lists in plain text documents. It's just so quick to use a plain text document for tasks that represent an agenda for one single day.. I don't have to navigate a UI or be tempted to set up a bunch of other parameters (priority, due date, tags, etc.).

Don't get me wrong, I love the fuller feature set an app provides. I love using Habitica to gamify my life and set up longer term goals and repeating habits. It would be great to combine it all into one app though, where I can quickly set up a bunch of simple tasks, but also have the option to get more detailed and use other features if I want to. I prefer to use something that has a minimalist appearance and usability, but that offers a deeper feature set for tasks you wish to put a little more planning into.

These are the ideas that drive the development of TaskNerd. Hopefully, it will end up being useful to both myself and others.

### Daily, Weekly, and Monthly Tasks:
These views allow you to create tasks that automatically reset/repeat every day, week, or month.
##### Counter / Goal Numbers:
  - There are two numbers to the right of every repeating task. Example: "2/7"
  - The number to the left of the "/" represents the number of times you've checked off that task within the time frame (the "counter").
  - The number to the right of the "/" represents the ideal number of times you would like to check off the task within the time frame (the "goal").
  - Use Case Example: Perhaps you'd like to go for a morning run at least 5 times every week. You'd go to the "Weekly" tab, make a new task called "Morning Run", and go to the edit view for that task to set the goal to 5. If you check off the task 3 times, then "3/5" is displayed to the right of the task. This means you've done it 3 times out of the 5 times you were planning to do it.
  - The counter can move past the goal amount to allow you to go above and beyond your original ambition.
  - The counter will reset once a new day, week, or month begins.
  
### One Off Tasks:
This tab lets you just create super simple tasks with a label and a check box. You can give them a priority, difficulty rating, and due date if you want but they work great without all the bells and whistles.

### Checklists:
This is a special tab that lets you work towards multi-step goals. Here you create a label for your task, then in edit mode you can add sub-tasks to it. As you check off your sub-tasks, you can exit edit view and see your progress displayed in the background of the task label. This kind of "progress bar" type visualization tends to be nice tool for motivation. I also like that the main view just simply shows the task and your progress to keep it simple for a quick peek at how you're doing.

### Priority and Difficulty Ratings:
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
	- Difficulty is indicated by which shape is shown. Easy tasks get a circle, medium tasks get a square, and hard tasks get a diamond.
	- The sorting logic for this was loosely inspired by the "[Eisenhower Matrix]", which uses importance instead of difficulty.
	  - A couple of notes about why I changed importance to difficulty:
	    - It seems to be easier (and therefore faster) for me to evaluate a task in terms of its difficulty rather than its importance.
		- It can also be a good way to get yourself started if you begin with something easy.
	  - Since the Eisenhower Matrix is meant to be a way to decide what to delegate and/or choose not to do, it didn't necessarily seem to fit in with the purpose of this app, which is mainly a to-do list. A project management tool seems to be a more fitting application for a true implementation of the Eisenhower Matrix... in fact, [here] is an interesting way to use Trello for something like this.

[//]: # (reference links below...)
   [habitica]: <https://habitica.com>
   [trello]: <https://trello.com>
   [Eisenhower Matrix]: <http://www.eisenhower.me/eisenhower-matrix/>
   [here]: <http://blog.trello.com/eisenhower-matrix-productivity-tool-trello-board>

