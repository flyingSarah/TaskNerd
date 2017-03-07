import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1
import QtQuick.Dialogs 1.2

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: item

    property int currentTabIndex

    Layout.fillHeight: true
    Layout.fillWidth: true
    anchors.fill: parent

    // ---------------------------------------------------------------- UI Stuff

    Rectangle {

        id: background

        color: Constants.windowBgColor
        anchors.fill: parent

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: Constants.windowMargins
            spacing: Constants.windowMargins

            // ---------------------------------------------------------------- Tool Bar

            TaskToolBar
            {
                id: taskToolBar

                onDeleteButtonClicked: {
                    taskViewRepeater.itemAt(currentTabIndex).enterDeleteMode()
                    setViewMode(Constants.viewModes[1])
                }
                onAddButtonClicked: taskViewRepeater.itemAt(currentTabIndex).addTask()
                onMenuButtonClicked: toolBarMenu.visible = isChecked
                onCancelButtonClicked: {
                    setViewMode(Constants.viewModes[0])
                    taskViewRepeater.itemAt(currentTabIndex).refreshTasks()
                }
            }

            // ---------------------------------------------------------------- Task Type Tabs

            TaskTabInfo
            {
                id: taskTabInfo
            }

            RowLayout
            {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: Constants.windowMargins/-2

                Repeater
                {
                    id: taskViewRepeater

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    model: taskTabInfo.countTables()

                    TaskListView
                    {
                        //anchors.fill: parent
                        visible: false
                        tabDelegate: "TaskRow"
                        tabTableName: taskTabInfo.dbNames()[index]
                        tabIndex: index
                        onUpdateDeleteCount: tabBar.numOfItemsToDelete = deleteCount
                    }

                    Component.onCompleted: {
                        //this shows the first view (should show the last view from the previous session)
                        currentTabIndex = Constants.tabInitIndex
                        taskViewRepeater.itemAt(currentTabIndex).visible = true
                    }
                }

                // ---------------------------------------------------------------- Tool Bar Menu

                ToolBarMenu
                {
                    id: toolBarMenu
                    Layout.fillHeight: true
                    onVisibleChanged: visible ? parent.spacing = 1 : parent.spacing = Constants.windowMargins/-2
                }
            }

            // ---------------------------------------------------------------- Tab Bar

            TabBar
            {
                id: tabBar

                onSelectedTabIndexChanged: {
                    currentTabIndex = selectedTabIndex
                    setCurrentTabToVisible(currentTabIndex)
                }
                onDeleteButtonClicked: {
                    taskViewRepeater.itemAt(currentTabIndex).deleteTasks()
                    setViewMode(Constants.viewModes[0])
                }
            }
        }
    }

    // ---------------------------------------------------------------- Helper functions

    function setCurrentTabToVisible(index)
    {
        for(var i = 0; i < taskViewRepeater.count; i++)
        {
            taskViewRepeater.itemAt(i).visible = (i === index)
        }
    }

    function setViewMode(viewMode)
    {
        taskToolBar.state = viewMode
        tabBar.state = viewMode
    }
}
