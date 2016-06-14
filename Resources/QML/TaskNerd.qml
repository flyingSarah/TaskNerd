import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

Item
{
    id: item

    property var tabNames: ["TaskRow", "TaskRow", "TaskRow", "TaskRow"]
    property var currentTab: tabNames[0]

    //signal taskCheckedChanged(string tabName, int index, bool taskIsChecked)

    Layout.fillHeight: true
	Layout.fillWidth: true
    anchors.fill: parent

    Rectangle {

        id: background

        color: 'lightgray' //mainwindow bg color
        anchors.fill: parent

        ColumnLayout
        {
            anchors.fill: parent
            anchors.margins: 5 //margins around mainwindow
            spacing: 5 //spacing between mainwindow pannels


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
                height: 26

                onSelectedTabButton: {

                    scrollLoader.active = false;
                    scrollLoader.visible = false;
                    if(tabIndex % 2)
                    {
                        scrollLoader.sourceComponent = regularTasks
                    }
                    else
                    {
                        scrollLoader.sourceComponent = weeklyTasks
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
                    tabDelegate: tabNames[0]
                    //onTabTaskCheckChanged: taskCheckedChanged(tab, task, checkBoxState)
                }
            }

            Component
            {
                id: weeklyTasks
                TaskListView
                {
                    tabModel: taskModel
                    tabDelegate: tabNames[1]
                    //onTabTaskCheckChanged: taskCheckedChanged(tab, task, checkBoxState)
                }
            }
        }
    }
}
