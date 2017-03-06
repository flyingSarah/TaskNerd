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

            // ---------------------------------------------------------------- Tool Bar

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
                    isMomentary: false
                    onButtonClick: taskViewRepeater.itemAt(background.currentTabIndex).deleteTask()
                }

                ToolBarButton
                {
                    charForIcon: "+"
                    onButtonClick: taskViewRepeater.itemAt(background.currentTabIndex).addTask()
                }

                ToolBarButton
                {
                    charForIcon: "..."
                    isMomentary: false
                    onButtonClick: toolBarMenu.visible = !toolBarMenu.visible
                }
            }

            // ---------------------------------------------------------------- Task Type Tabs

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

            // ---------------------------------------------------------------- Tab Bar

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

    // ---------------------------------------------------------------- Tool Bar Menu

    ToolBarMenu
    {
        id: toolBarMenu

        y: Constants.windowMargins + (Constants.buttonHeight * 0.75)
        x: parent.width - Constants.windowMargins - (Constants.buttonHeight / 4) - width
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
