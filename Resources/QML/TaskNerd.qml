import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: item

    Layout.fillHeight: true
    Layout.fillWidth: true
    anchors.fill: parent

    // ---------------------------------------------------------------- Menu Stuff

    MenuBar
    {
        Menu
        {
            title: "File"

            MenuItem
            {
                text: "Save"
                action: saveAction
            }

            MenuItem
            {
                text: "Revert"
                action: revertAction
            }
        }
    }

    Action
    {
        id: saveAction

        text: "Save"
        shortcut: StandardKey.Save
        onTriggered: {
            for(var i = 0; i < taskTabInfo.countTables(); i++)
            {
                taskViewRepeater.itemAt(i).save()
            }
            setCurrentTabToVisible(background.currentTabIndex)
        }
    }

    Action
    {
        id: revertAction

        text: "Revert"
        shortcut: "Ctrl+R"
        onTriggered: {
            for(var i = 0; i < taskTabInfo.countTables(); i++)
            {
                taskViewRepeater.itemAt(i).revert()
            }
            setCurrentTabToVisible(background.currentTabIndex)
        }
    }

    // ---------------------------------------------------------------- UI Stuff

    Rectangle {

        id: background

        property int currentTabIndex

        color: Constants.windowBgColor
        anchors.fill: parent

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: Constants.windowMargins
            spacing: Constants.windowMargins

            RowLayout
            {
                id: toolRow

                spacing: Constants.tabBarSpacing

                width: parent.width
                height: Constants.taskRowHeight

                Layout.alignment: Qt.AlignRight

                //TODO: I probably need a special mode button for the delete button so that it can stay selected for delete mode
                //...and then be intentionally exited
                ToolBarButton
                {
                    charForIcon: "-"

                    onButtonClick: {
                        for(var i = 0; i < taskViewRepeater.count; i++)
                        {
                            taskViewRepeater.itemAt(i).deleteTask()
                        }
                    }
                }

                ToolBarButton
                {
                    charForIcon: "+"

                    onButtonClick: {
                        taskViewRepeater.itemAt(background.currentTabIndex).addTask()
                    }
                }
            }

            TaskTabInfo
            {
                id: taskTabInfo
            }

            Repeater
            {
                id: taskViewRepeater

                Layout.fillWidth: true
                Layout.fillHeight: true

                model: taskTabInfo.countTables()

                TaskListView
                {
                    visible: false
                    tabDelegate: "TaskRow"
                    tabTableName: taskTabInfo.dbNames()[index]
                    tabIndex: index
                }

                Component.onCompleted: {

                    //this shows the first view (should show the last view from the previous session)
                    taskViewRepeater.itemAt(Constants.tabInitIndex).visible = true
                    background.currentTabIndex = Constants.tabInitIndex
                }
            }

            //bottom tab bar with radio buttons for the different task lists
            TabBar
            {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                height: Constants.buttonHeight

                onSelectedTabButton: {

                    background.currentTabIndex = tabIndex
                    setCurrentTabToVisible(tabIndex)
                }
            }
        }
    }

    // ---------------------------------------------------------------- Helper functions

    function setCurrentTabToVisible(index)
    {
        for(var i = 0; i < taskViewRepeater.count; i++)
        {
            if(i !== index)
            {
                taskViewRepeater.itemAt(i).visible = false
            }
            else
            {
                taskViewRepeater.itemAt(i).visible = true
            }
        }
    }
}
