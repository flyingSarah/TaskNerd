import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    property string tabTableName
    property string tabIndex

    property var rowsToDelete: []
    property var rowsToArchive: []

    signal updateDeleteCount(int deleteCount)
    signal updateArchiveCount(int archiveCount)
    signal enterEditMode()

    TaskModel
    {
        id: taskModel
    }

    Repeater
    {
        id: editViewRepeater

        anchors.fill: parent

        model: taskModel

        TaskEditView
        {
            id: editView

            width: editViewRepeater.width
            height: editViewRepeater.height

            row: index
            visible: false

            checklistData: taskModel.relatedData(index, 'count')
            onGetChecklistData: checklistData = taskModel.relatedData(index, 'count')
            onUpdateChecklistProgress: taskRepeater.itemAt(index).updateChecklistProgress(progressIndex, progressValue)
            onAddIndexToChecklistProgress: taskRepeater.itemAt(index).addIndexToChecklistProgress()
            onDeleteIndexFromChecklistProgress: taskRepeater.itemAt(index).deleteIndexFromChecklistProgress(progressIndex)
        }
    }

    ScrollView
    {
        id: scrollView

        anchors.fill: parent

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
            /*console.log("flickable item content height changed", taskRepeater.finCount, taskRepeater.count)
            if(taskRepeater.finCount == taskRepeater.count)
            {
                flickableItem.contentY = 300
            }
            taskRepeater.finCount++*/
        }

        flickableItem.onContentYChanged: {
            //console.log("flickable item content y changed", flickableItem.contentY, flickableItem.contentHeight)
        }

        ColumnLayout
        {
            anchors.top: parent.top
            width: scrollView.width - 2
            spacing: 0

            // ---------------------------------------------------------------- List of Tasks

            Repeater
            {
                id: taskRepeater

                property int finCount: 0

                width: parent.width
                model: taskModel

                RowLayout
                {
                    TaskRow
                    {
                        id: taskRow
                        Layout.fillWidth: true
                        Layout.minimumHeight: Constants.taskRowHeight
                        checklistProgress: findChecklistProgress(taskModel.relatedData(index, 'count'))
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
                            enterEditMode()
                            scrollView.visible = false
                            editViewRepeater.itemAt(index).visible = true
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
                        editModeRow.reset()
                        taskRow.initTaskRowElements()
                    }

                    function updateChecklistProgress(progressIndex, progressValue)
                    {
                        taskRow.updateChecklistProgress(progressIndex, progressValue)
                    }
                    function addIndexToChecklistProgress()
                    {
                        taskRow.addIndexToChecklistProgress()
                    }
                    function deleteIndexFromChecklistProgress(ind)
                    {
                        taskRow.deleteIndexFromChecklistProgress(ind)
                    }
                }

                Component.onCompleted: {
                    //set up the model(s) - task, param, and map models all need to be referenced
                    var sortList = ["priority", "difficulty"]
                    tabTableName.search('checklist') > -1 ? taskModel.setupModel(tabTableName, sortList, 'checklistChecklistParams', 'checklistCount', 'count')
                                                          : taskModel.setupModel(tabTableName, sortList)
                    refreshTasks()
                }
            }

            onVisibleChanged: scrollView.frameVisible = visible
        }
    }

    // ---------------------------------------------------------------- Helper functions

    function refreshTasks()
    {
        taskModel.select()
        rowsToDelete = []
        rowsToArchive = []
        updateDeleteCount(0)
        updateArchiveCount(0)

        for(var i = 0; i < editViewRepeater.count; i++)
        {
            editViewRepeater.itemAt(i).visible = false
            taskRepeater.itemAt(i).refreshTask()
        }
        scrollView.visible = true

        editMode(false)
    }

    function addTask()
    {
        taskModel.insertNewRecord(taskTabInfo.taskDefaultMaps()[tabIndex])
        refreshTasks()

        //when adding a task adjust the scroll area so you can see the added task at the bottom
        var pos = scrollView.flickableItem.contentHeight - scrollView.flickableItem.height
        if(pos > 0)
        {
            scrollView.flickableItem.contentY = pos
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

    function findChecklistProgress(checklistData)
    {
        var progress = []
        for(var row in checklistData)
        {
            progress.push(checklistData[row]['isChecked'])
        }

        return progress
    }

    onVisibleChanged: if(visible) refreshTasks()
}


