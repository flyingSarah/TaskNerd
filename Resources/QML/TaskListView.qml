import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

ScrollView
{
    id: scrollView

    property string tabDelegate
    property string tabTableName
    property string tabIndex

    //property bool isRepeating: taskTabInfo.canRepeat()[tabIndex];
    //property bool hasChecklist: taskTabInfo.hasChecklist()[tabIndex];

    Layout.fillWidth: true
    Layout.fillHeight: true

    frameVisible: true
    highlightOnFocus: true

    style: ScrollViewStyle {
        transientScrollBars: true
        handle: Item {
            //scroll bar handle size & appearance
            implicitWidth: Constants.scrollBarWidth
            implicitHeight: Constants.scrollBarHeight
            Rectangle {
                color: Constants.scrollBarColor
                border.color: Constants.scrollBarBC
                border.width: Constants.scrollBarBW
                anchors.fill: parent
                anchors.margins: 2
            }
        }
        scrollBarBackground: Item {
            implicitWidth: Constants.scrollBarWidth
            implicitHeight: Constants.scrollBarHeight
        }
    }

    ColumnLayout
    {
        id: taskList
        anchors.top: parent.top
        width: scrollView.width - 2
        Layout.fillWidth: true
        spacing: 0

        Repeater
        {
            id: taskRepeater

            property int finCount: 0

            width: parent.width
            model: TaskModel {

                id: taskModel
            }

            TaskRow
            {
                Layout.fillWidth: true
                modelRef: taskModel
            }

            Component.onCompleted: {
                taskModel.setupModel(tabTableName)
                refreshTasks()
            }
        }
    }

    //TODO: set scroll bar positions and have them appear at the correct positions when loaded
    // .... from the main view (when the app starts they can all start from the top position

    flickableItem.onContentHeightChanged: {
        //console.log("flickable item content height changed", taskRepeater.finCount, taskRepeater.count)
        if(taskRepeater.finCount == taskRepeater.count)
        {
            //flickableItem.contentY = 300
        }
        taskRepeater.finCount++
    }

    flickableItem.onContentYChanged: {
        //console.log("flickable item content y changed", flickableItem.contentY, flickableItem.contentHeight)
    }

    // ---------------------------------------------------------------- Helper functions

    function refreshTasks()
    {
        for(var i = 0; i < taskRepeater.count; i++)
        {
            taskRepeater.itemAt(i).initTaskMap()
            taskRepeater.itemAt(i).loadTaskElements()
        }
    }

    function addTask()
    {
        taskModel.insertNewRecord(taskModel.count, taskTabInfo.paramDefaultMaps()[tabIndex])
        save()

        //when adding a task adjust the scroll area so you can see the added task at the bottom
        var pos = flickableItem.contentHeight - flickableItem.height
        if(pos > 0)
        {
            flickableItem.contentY = pos
        }
    }

    function deleteTask()
    {
        for(var i = 0; i < taskRepeater.count; i++)
        {
            taskRepeater.itemAt(i).enterDeleteMode()
        }
    }

    function save()
    {
        visible = true
        taskModel.submitAll()
        refreshTasks()
    }

    function revert()
    {
        visible = true
        taskModel.revertAll()
        taskModel.select()
        refreshTasks()
    }
}
