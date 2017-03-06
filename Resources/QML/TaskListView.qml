import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1
import QtQuick.Dialogs 1.2

import com.swhitley.models 1.0

import "Constants.js" as Constants

ScrollView
{
    id: scrollView

    property string tabDelegate
    property string tabTableName
    property string tabIndex

    property var rowsToDelete: []

    //property bool isRepeating: taskTabInfo.canRepeat()[tabIndex];
    //property bool hasChecklist: taskTabInfo.hasChecklist()[tabIndex];

    Layout.fillWidth: true
    Layout.fillHeight: true

    frameVisible: true
    highlightOnFocus: true

    // ---------------------------------------------------------------- Scroll Bar
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

    ColumnLayout
    {
        id: taskList
        anchors.top: parent.top
        width: scrollView.width - 2
        Layout.fillWidth: true
        spacing: 0

        // ---------------------------------------------------------------- List of Tasks
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

                onDeleteThisRow: doDelete ? rowsToDelete.push(row) : rowsToDelete.splice(rowsToDelete.lastIndexOf(row), 1)
            }

            Component.onCompleted: {
                taskModel.setupModel(tabTableName)
                refreshTasks()
            }
        }

        // ---------------------------------------------------------------- Delete Alert Message
        Item
        {
            MessageDialog
            {
                id: deleteMessage

                property var numItems

                title: "Delete Tasks"
                text: "Are you sure you want to delete " + numItems + " tasks?"
                standardButtons: StandardButton.Yes | StandardButton.No
                onYes: deleteTasks(rowsToDelete)
                onNo: resetAfterDelete()
            }
        }
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
        taskModel.select()
        refreshTasks()

        //when adding a task adjust the scroll area so you can see the added task at the bottom
        var pos = flickableItem.contentHeight - flickableItem.height
        if(pos > 0)
        {
            flickableItem.contentY = pos
        }
    }

    function deleteMode(isChecked)
    {
        if(isChecked)
        {
            //go into delete mode
            for(var i = 0; i < taskRepeater.count; i++)
            {
                taskRepeater.itemAt(i).enterDeleteMode()
            }
        }
        else
        {
            //delete the tasks
            if(rowsToDelete.length > 1)
            {
                deleteMessage.numItems = rowsToDelete.length
                deleteMessage.open()
            }
            else
            {
                deleteTasks(rowsToDelete)
            }
        }
    }

    function deleteTasks(rows)
    {
        rows = rows.sort(function(a,b){return b-a})

        for(var row in rows)
        {
            taskModel.removeRows(rows[row], 1)
        }

        taskModel.select()
        resetAfterDelete()
    }

    function resetAfterDelete()
    {
        rowsToDelete = []
        refreshTasks()
    }
}
