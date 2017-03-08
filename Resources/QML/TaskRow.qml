import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: taskItem

    property var modelRef
    property var taskDataMap: ({})

    implicitHeight: Constants.taskRowHeight
    Layout.fillWidth: true

    //--------------------------------------------------------------- Main Task Row
    RowLayout
    {
        spacing: Constants.taskRowSpacing

        width: parent.width
        height: parent.height

        //--------------------------------------------------------------- Priority / Difficulty Indicator

        Rectangle
        {
            id: taskColor

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
                text: taskDataMap['label']
                onTextChanged: {
                    taskDataMap['label'] = text
                    modelRef.setRecord(index, taskDataMap)
                }
            }
        }
    }

    //--------------------------------------------------------------- Helper Functions

    function refreshTask()
    {
        initTaskMap()
        loadTaskElements()
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
        taskColor.color = Constants.taskColors[taskDataMap['priority']][taskDataMap['difficulty']]
        labelLoader.sourceComponent = label

        //determine which dynamic task elements to load
        if(taskDataMap.hasOwnProperty('isChecked'))
        {
            checkBox.visible = true
        }
    }
}
