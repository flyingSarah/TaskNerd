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

    property var rowsToDelete: []
    property var rowsToArchive: []

    signal updateDeleteCount(int deleteCount)
    signal updateArchiveCount(int archiveCount)
    signal editRow(int row, var taskMap)

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
                anchors.margins: Constants.scrollBarMargin
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

            RowLayout
            {
                TaskRow
                {
                    id: taskRow
                    modelRef: taskModel
                    onUpdateRow: saveTasks(index, taskMap)
                }

                EditModeRow
                {
                    id: editModeRow
                    visible: false
                    onDeleteThisRow: {
                        doDelete ? rowsToDelete.push(index) : rowsToDelete.splice(rowsToDelete.lastIndexOf(index), 1)
                        updateDeleteCount(rowsToDelete.length)
                    }
                    onArchiveThisRow: {
                        doArchive ? rowsToArchive.push(index) : rowsToArchive.splice(rowsToArchive.lastIndexOf(index), 1)
                        updateArchiveCount(rowsToArchive.length)
                    }
                    onEditThisRow: {
                        editRow(index, taskRow.taskDataMap)
                    }
                }

                Item
                {
                    width: Constants.taskRowRightSpacing
                }

                function editMode(enabled)
                {
                    editModeRow.visible = enabled
                    taskRow.enabled = !enabled
                }

                function refreshTask()
                {
                    taskRow.refreshTask()
                    editModeRow.reset()
                }
            }

            Component.onCompleted: {
                taskModel.setupModel(tabTableName)
                refreshTasks()
            }
        }
    }

    // ---------------------------------------------------------------- Helper functions

    function refreshTasks()
    {
        rowsToDelete = []
        rowsToArchive = []
        updateDeleteCount(0)
        updateArchiveCount(0)

        for(var i = 0; i < taskRepeater.count; i++)
        {
            taskRepeater.itemAt(i).refreshTask()
        }
        editMode(false)
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

    function editMode(enabled)
    {
        for(var i = 0; i < taskRepeater.count; i++)
        {
            taskRepeater.itemAt(i).editMode(enabled)
        }
    }

    function deleteTasks()
    {
        rowsToDelete = rowsToDelete.sort(function(a,b){return b-a})

        for(var row in rowsToDelete)
        {
            taskModel.removeRows(rowsToDelete[row], 1)
        }

        taskModel.select()
        refreshTasks()
    }

    function archiveTasks()
    {
        rowsToArchive = rowsToArchive.sort(function(a,b){return b-a})

        for(var row in rowsToArchive)
        {
            console.log("archive these rows", rowsToArchive)
        }

        refreshTasks()
    }

    function saveTasks(row, taskMap)
    {
        taskModel.setRecord(row, taskMap)
    }
}
