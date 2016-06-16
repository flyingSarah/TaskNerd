import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

import "Constants.js" as Constants

Item
{
    id: item

    //signal taskCheckedChanged(string tabName, int index, bool taskIsChecked)

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


            //a stackoverflow thread helped me put this together:
            //... http://stackoverflow.com/questions/13049896/qml-navigation-between-qml-pages-from-design-perception

            //tab loader to show different views
            Loader {
                id: scrollLoader

                Layout.fillWidth: true
                Layout.fillHeight: true

                active: false
                asynchronous: true
                visible: false
                sourceComponent: regularTasks
                onVisibleChanged: loadIfNotLoaded()
                Component.onCompleted: loadIfNotLoaded()

                function loadIfNotLoaded()
                {
                    if(visible && !active)
                    {
                        active = true
                    }
                }
            }

            //bottom tab bar with radio buttons for the different task lists
            TabBar
            {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                height: Constants.buttonHeight

                onSelectedTabButton: {

                    scrollLoader.active = false;
                    scrollLoader.visible = false;
                    if(tabIndex % 2)
                    {
                        scrollLoader.sourceComponent = weeklyTasks
                    }
                    else
                    {
                        scrollLoader.sourceComponent = regularTasks
                    }

                    scrollLoader.visible = true
                }
            }

            Component
            {
                id: regularTasks
                TaskListView
                {
                    tabModel: taskModel
                    tabDelegate: "TaskRow"
                    //onTabTaskCheckChanged: taskCheckedChanged(tab, task, checkBoxState)
                }
            }

            Component
            {
                id: weeklyTasks
                TaskListView
                {
                    tabModel: weeklyTaskModel
                    tabDelegate: "TaskRow" //TODO: make a new row type for repeating tasks
                    //onTabTaskCheckChanged: taskCheckedChanged(tab, task, checkBoxState)
                }
            }
        }
    }
}
