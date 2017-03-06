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
        anchors.verticalCenter: parent.verticalCenter
        spacing: Constants.taskRowSpacing

        width: parent.width
        height: parent.height

        //--------------------------------------------------------------- Task Color (priority / difficulty)

        Rectangle
        {
            id: taskColor

            width: Constants.taskColorWidth
            height: Constants.taskColorHeight

            color: Constants.windowBgColor
        }

        //--------------------------------------------------------------- Check Box
        Loader
        {
            id: checkBoxLoader

            Layout.preferredWidth: Constants.buttonHeight
            Layout.preferredHeight: Constants.buttonHeight
        }

        Component
        {
            id: checkBoxComponent

            TaskCheckBox
            {
                _taskDataMap: taskDataMap

                anchors.fill: checkBoxLoader

                onUpdateTaskDataMap: {
                    taskDataMap = taskDataMap_
                    modelRef.setRecord(index, taskDataMap)
                }
            }
        }

        //--------------------------------------------------------------- Delete & Edit Mode Components)
        Component
        {
            id: deleteModeComponent

            ToolBarButton
            {
                charForIcon: "X"
                isMomentary: false
                onButtonClick: isChecked ? deleteThisRow(index, true) : deleteThisRow(index, false)
            }
        }

        //--------------------------------------------------------------- Task Label
        Loader
        {
            id: labelLoader

            Layout.fillWidth: true
            Layout.minimumWidth: 50
            Layout.maximumWidth: 1600
            Layout.preferredHeight: Constants.buttonHeight
        }

        Component
        {
            id: labelComponent

            TaskLabel
            {
                _taskDataMap: taskDataMap

                anchors.fill: labelLoader

                onUpdateTaskDataMap: {
                    taskDataMap = taskDataMap_
                    modelRef.setRecord(index, taskDataMap)
                }
            }
        }

        //--------------------------------------------------------------- Right Spacing
        Item
        {
            width: Constants.taskRowRightSpacing
            height: Constants.buttonHeight
        }
    }

    //--------------------------------------------------------------- Helper Functions

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
        //determine which task elements to load
        if(taskDataMap.hasOwnProperty('priority') && taskDataMap.hasOwnProperty('difficulty'))
        {
            taskColor.color = Constants.taskColors[taskDataMap['priority']][taskDataMap['difficulty']]
        }
        if(taskDataMap.hasOwnProperty('isChecked'))
        {
            checkBoxLoader.sourceComponent = checkBoxComponent
        }
        if(taskDataMap.hasOwnProperty('label'))
        {
            labelLoader.sourceComponent = labelComponent
        }
    }

    function enterDeleteMode()
    {
        checkBoxLoader.sourceComponent = deleteModeComponent
        labelLoader.enabled = false
    }
}
