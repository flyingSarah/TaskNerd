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

    Rectangle {

        id: background

        color: Constants.windowBgColor
        anchors.fill: parent

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: Constants.windowMargins
            spacing: Constants.windowMargins

            TaskListView
            {
                id: regularTasks
                visible: false
                focus: false
                //tabModel: taskModel
                tabDelegate: "TaskRow"
                tabTableName: "tasks"
            }

            TaskListView
            {
                id: weeklyTasks
                visible: false
                focus: false
                //tabModel: weeklyTaskModel
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

                    if(tabIndex % 2)
                    {
                        regularTasks.visible = false
                        regularTasks.focus = false
                        weeklyTasks.visible = true
                        weeklyTasks.focus = true
                    }
                    else
                    {
                        weeklyTasks.visible = false
                        weeklyTasks.focus = false
                        regularTasks.visible = true
                        regularTasks.focus = true
                    }
                }
            }
        }
    }
}
