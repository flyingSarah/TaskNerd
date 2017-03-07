import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: taskItem

    property var modelRef
    property var taskDataMap: ({})

    signal deleteThisRow(int row, bool doDelete)

    implicitHeight: Constants.taskRowHeight

    //--------------------------------------------------------------- Main Task Row
    RowLayout
    {
        //anchors.verticalCenter: parent.verticalCenter
        spacing: Constants.taskRowSpacing

        width: parent.width
        height: parent.height

        //--------------------------------------------------------------- Delete & Edit Mode Components

        RowLayout
        {
            id: deleteMode

            visible: false
            onVisibleChanged: {
                if(!visible)
                {
                    deleteButton.reset()
                    archiveButton.reset()
                }
            }

            Item
            {
                width: Constants.taskRowSpacing
            }

            ToolBarButton
            {
                id: deleteButton
                buttonText: "x"
                isMomentary: false
                onButtonClick: deleteThisRow(index, isChecked)
            }

            ToolBarButton
            {
                id: archiveButton
                buttonText: "a"
                isMomentary: false
            }
        }

        //--------------------------------------------------------------- Priority / Difficulty Indicator

        Rectangle
        {
            id: taskColorLeft

            width: Constants.taskColorWidth
            height: Constants.taskColorHeight

            color: Constants.windowBgColor
        }

        //--------------------------------------------------------------- Check Box

        TaskCheckBox
        {
            id: checkBox
            visible: false
            onVisibleChanged: if(visible) isChecked = taskDataMap['isChecked']
            onIsCheckedChanged: {
                taskDataMap['isChecked'] = isChecked
                modelRef.setRecord(index, taskDataMap)
            }

        }

        //--------------------------------------------------------------- Task Label
        Loader
        {
            id: labelLoader

            Layout.fillWidth: true
            Layout.minimumWidth: 50
            Layout.preferredHeight: Constants.buttonHeight
        }

        Component
        {
            id: label

            TaskLabel
            {
                labelText: taskDataMap['label']
                onLabelTextChanged: {
                    taskDataMap['label'] = labelText
                    modelRef.setRecord(index, taskDataMap)
                }
            }

        }

        //--------------------------------------------------------------- Priority / Difficulty Indicator
        Rectangle
        {
            id: taskColorRight

            width: Constants.taskColorWidth
            height: Constants.taskColorHeight

            color: Constants.windowBgColor
        }
    }

    //--------------------------------------------------------------- Helper Functions

    function refreshTask()
    {
        deleteMode.visible = false
        initTaskMap()
        loadTaskElements()
        labelLoader.enabled = true
        checkBox.enabled = true
    }

    function initTaskMap()
    {
        //get starting map for task data -- this map gets updated and sent back to the model for saving
        var data = modelRef.getDataMap(index);
        for (var k in data)
        {
            if(data.hasOwnProperty(k) && k !== 'id')
            {
                taskDataMap[k] = data[k]
            }
        }
    }

    function loadTaskElements()
    {
        //always load these elements
        var taskColor = Constants.taskColors[taskDataMap['priority']][taskDataMap['difficulty']]
        taskColorRight.color = taskColor
        taskColorLeft.color = taskColor
        labelLoader.sourceComponent = label

        //determine which dynamic task elements to load
        if(taskDataMap.hasOwnProperty('isChecked'))
        {
            checkBox.visible = true
        }
    }

    function enterDeleteMode()
    {
        deleteMode.visible = true
        labelLoader.enabled = false
        checkBox.enabled = false
    }
}
