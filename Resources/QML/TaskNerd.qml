import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

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
            console.log("submit")
            regularTasks.save()
            weeklyTasks.save()
            setCurrentTabToVisible(background.currentTabIndex)
        }
    }

    Action
    {
        id: revertAction

        text: "Revert"
        shortcut: "Ctrl+R"
        onTriggered: {
            console.log("revert")
            regularTasks.revert()
            weeklyTasks.revert()
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

                spacing: Constants.taskRowSpacing

                width: parent.width
                height: Constants.taskRowHeight

                Layout.alignment: Qt.AlignRight

                Rectangle
                {
                    width: Constants.buttonHeight
                    height: Constants.buttonHeight

                    color: Constants.taskCheckBoxUC
                    border.color: Constants.taskItemBorderColor
                    border.width: Constants.taskItemBorderWidth

                    Text
                    {
                        id: addButtonText
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: "+"

                        font.family: Constants.appFont
                        font.pixelSize: Constants.appFontSize
                        color: Constants.taskLabelTextColor
                    }

                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked: {
                            if(regularTasks.visible)
                            {
                                regularTasks.addTask()
                            }
                            else if(weeklyTasks.visible)
                            {
                                weeklyTasks.addTask()
                            }
                        }

                        onPressed: {
                            parent.color = Constants.taskCheckBoxCC
                            addButtonText.color = Constants.taskCheckBoxUC
                        }

                        onReleased: {
                            parent.color = Constants.taskCheckBoxUC
                            addButtonText.color = Constants.taskLabelTextColor
                        }
                    }
                }
            }

            TaskListView
            {
                id: regularTasks
                visible: false
                focus: false
                tabDelegate: "TaskRow"
                tabTableName: "tasks"
            }

            TaskListView
            {
                id: weeklyTasks
                visible: false
                focus: false
                tabDelegate: "TaskRow"
                tabTableName: "weeklyTasks"
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
        if(index === 0)
        {
            weeklyTasks.visible = false
            regularTasks.visible = true
        }
        else
        {
            regularTasks.visible = false
            weeklyTasks.visible = true
        }
    }
}
