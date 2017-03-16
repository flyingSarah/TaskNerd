import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    property string tabTabelName
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

            hasChecklist: tabTabelName.search('checklist')+1 ? true : false
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
                    }
                }

                Component.onCompleted: {
                    //set up the model(s) - task, param, and map models all need to be referenced
                    var didSetupModel = false
                    tabTabelName.search('checklist')+1 ? didSetupModel = taskModel.setupModel(tabTabelName, 'checklistChecklistParams', 'checklistCount', 'count')
                                                       : didSetupModel = taskModel.setupModel(tabTabelName)
                    refreshTasks()
                }
            }

            onVisibleChanged: scrollView.frameVisible = visible
        }
    }

    // ---------------------------------------------------------------- Helper functions

    function refreshTasks()
    {
        rowsToDelete = []
        rowsToArchive = []
        updateDeleteCount(0)
        updateArchiveCount(0)

        for(var i = 0; i < editViewRepeater.count; i++)
        {
            editViewRepeater.itemAt(i).visible = false
        }
        scrollView.visible = true

        editMode(false)
    }

    function addTask()
    {
        taskModel.insertNewRecord(taskModel.count, taskTabInfo.taskDefaultMaps()[tabIndex])
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
}


