.pragma library

// ------------------------------------------------------------------ General App Constants

var windowMargins   = 5;  //margins around mainwindow and its pannels
var buttonHeight    = 26;  //height of generic buttons throughout app
var scrollBarWidth  = 10;
var scrollBarHeight = 26;
var scrollBarBW     = 1; //border width of scroll bar
var scrollBarMargin = 2;

var windowBgColor   = 'white';    //mainwindow bg color
var scrollBarColor  = 'transparent';
var scrollBarBC     = 'gray'; //border color of scroll bar

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

var tabButtonSC     = 'gray'; //selected color of tab bar buttons
var tabButtonUC     = 'transparent'; //unselected color of tab bar buttons
var tabButtonBC     = 'gray'; //border color of tab buttons
var tabButtonSTC    = 'lightgray'; //selected text color of tab buttons
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

var taskItemBorderColor = 'gray'; //for any item in the task row
var taskCheckBoxCC      = 'gray'; //checked color of task checkbox
var taskCheckBoxUC      = 'white'; //unchecked color of task checkbox
var taskLabelBgColor    = 'white'; //background color of task label
var taskLabelTextColor  = 'gray';

var editModeButtonWidth = 30
var editModeButtonHeight= taskRowHeight-2
var editModeSpacing     = 2
var editModeBorderWidth = 0

// ------------------------------------------------------------------ Edit View

var editViewRowHeight   = 18

// ------------------------------------------------------------------ Task Parameters

//task colors - outer list is priority, inner list is difficulty
var taskColors = [['#ffb8c0', '#ff7286', '#ff001e'],
                  ['#ffd1ad', '#ffaf72', '#ff8426'],
                  ['#fff99e', '#fff771', '#fff029'],
                  ["#b2f0b4", '#5ce061', '#22b026'],
                  ['#9ebdff', '#5792ff', '#004bea']]

var priorityOptions     = ['Highest', 'High', 'Medium', 'Low', 'Lowest']
var difficultyOptions   = ['Easy', 'Medium', 'Hard']
