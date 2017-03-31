.pragma library

// ------------------------------------------------------------------ General App Constants

var windowMargins   = 5;  //margins around mainwindow and its pannels
var buttonHeight    = 26;  //height of generic buttons throughout app
var scrollBarWidth  = 10;
var scrollBarHeight = 26;
var scrollBarBW     = 1; //border width of scroll bar
var scrollBarMargin = 2;

var windowBgColor   = '#1c1025';    //mainwindow bg color
var borderColor     = '#453550'
var borderWidth     = 1
var scrollBarColor  = 'transparent';

var appFont         = 'Avenir';
var appFontSize     = 14;
var appMiniFontSize = 11;

var viewModes   = ['taskList', 'editMode', 'editView']

// ------------------------------------------------------------------ Tool Bar

var menuWidth       = 80;
var menuItems       = ['archive view'];

// ------------------------------------------------------------------ Tab Bar
var tabBarSpacing   = 3; //spacing between buttons in the tab bar

var selectColor     = '#655570'; //selected color of tab bar buttons
var unselectColor   = windowBgColor; //unselected color of tab bar buttons
var buttonTextColor = '#b5a5c0';

var tabInitIndex    = 0; //initial index of the task views that are shown on open

// ------------------------------------------------------------------ Task Row

var taskRowHeight       = 29;
var taskRowSpacing      = 3;
var taskRowMargin  = 4;
var shapeWidth          = 7; //shape is the element on the left that indicates priority and difficulty
var shapeHeight         = taskRowHeight-1;
var taskLabelMaxChars   = 75;
var taskLabelTextColor  = '#bbbbbb';

// ------------------------------------------------------------------ Edit Mode and View

var editModeButtonWidth = 25
var editModeButtonHeight= taskRowHeight-2
var editModeSpacing     = 2
var editModeBorderWidth = 0

var editViewRowHeight   = 22

// ------------------------------------------------------------------ Task Parameters

var priorities = ['#ff7286', '#ff9f62', '#fff771', '#5ce061', '#5792ff']
var difficulties = ['l', 'n', 'u']
var priorityOptions     = ['Highest', 'High', 'Medium', 'Low', 'Lowest']
var difficultyOptions   = ['Easy', 'Medium', 'Hard']
