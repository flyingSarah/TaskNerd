.pragma library

// ------------------------------------------------------------------ General App Constants

var windowMargins   = 5;  //margins around mainwindow and its pannels
var buttonHeight    = 26;  //height of generic buttons throughout app
var scrollBarWidth  = 10;
var scrollBarHeight = 26;
var scrollBarBW     = 1; //border width of scroll bar
var scrollBarMargin = 2;

var windowBgColor   = '#151515';    //mainwindow bg color
var scrollBarColor  = 'transparent';
var scrollBarBC     = '#555555'; //border color of scroll bar

var appFont         = 'Futura Medium';
var appFontSize     = 14;

var viewModes   = ['taskList', 'editMode', 'editView']

// ------------------------------------------------------------------ Tool Bar

var toolBarButtonC  = windowBgColor; // color of the tool bar buttons

var menuWidth       = 80;
var menuColor       = '#f5f5f5'
var menuBC          = '#bbbbbb'
var menuFontSize    = 11;
var menuItems       = ['archive view'];

// ------------------------------------------------------------------ Tab Bar
var tabBarSpacing   = 5; //spacing between buttons in the tab bar
var tabButtonBW     = 1; //border width of tab Buttons

var tabButtonSC     = '#cccccc'; //selected color of tab bar buttons
var tabButtonUC     = 'transparent'; //unselected color of tab bar buttons
var tabButtonBC     = scrollBarBC; //border color of tab buttons
var tabButtonSTC    = '#2a2a2a'; //selected text color of tab buttons
var tabButtonUTC    = 'gray'; //unselected text color of tab buttons

var tabInitIndex    = 0; //initial index of the task views that are shown on open

// ------------------------------------------------------------------ Task Row

var taskRowHeight       = 29;
var taskRowSpacing      = 3;
var taskRowRightSpacing = 7;
var taskColorWidth      = 7; //task color is the color on the left that is determined from the priority and difficulty
var taskColorHeight     = taskRowHeight - 2;
var taskItemBorderWidth = 1; //for any item in the task row
var taskLabelLeftMargin = 5;
var taskLabelMaxChars   = 75;

var taskItemBorderColor = scrollBarBC; //for any item in the task row
var taskCheckBoxCC      = '#555555'; //checked color of task checkbox
var taskCheckBoxUC      = 'transparent'; //unchecked color of task checkbox
var taskLabelBgColor    = 'transparent'; //background color of task label
var taskLabelTextColor  = '#cccccc';

var editModeButtonWidth = 30
var editModeButtonHeight= taskRowHeight-2
var editModeSpacing     = 2
var editModeBorderWidth = 1

// ------------------------------------------------------------------ Edit View

var editViewRowHeight   = 18

// ------------------------------------------------------------------ Task Parameters

//task colors - outer list is priority, inner list is difficulty

var taskColors = [['#ffffb8c0', '#eeff7286', '#ddff254e'],
                  ['#ffffc19d', '#eeff9f62', '#ffff8426'],
                  ['#fffff99e', '#eefff771', '#eefff029'],
                  ["#ff82ff84", '#ff5ce061', '#ee22b026'],
                  ['#ff8eadff', '#ff5792ff', '#ee004bea']]


var priorityOptions     = ['Highest', 'High', 'Medium', 'Low', 'Lowest']
var difficultyOptions   = ['Easy', 'Medium', 'Hard']

