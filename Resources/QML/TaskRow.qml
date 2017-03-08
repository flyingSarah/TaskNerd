import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: taskItem

    property var modelRef
    property var taskDataMap: ({})

    signal updateRow(var taskMap)

    Layout.minimumHeight: Constants.taskRowHeight
    Layout.fillWidth: true

    //--------------------------------------------------------------- Main Task Row

    RowLayout
    {
        spacing: Constants.taskRowSpacing

        width: parent.width

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
                updateRow(taskDataMap)
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
            id: labelComponent

            TaskLabel
            {
                text: taskDataMap['label']
                onVisibleChanged: if(visible) text = taskDataMap['label']
                onTextChanged: {
                    taskDataMap['label'] = text
                    updateRow(taskDataMap)
                }
            }
        }

        //--------------------------------------------------------------- Repeat Indicator
        Loader
        {
            id: repeatLoader
        }

        Component
        {
            id: repeatComponent

            Text
            {
                text: '0/'+taskDataMap['repeat'] //TODO: replace the '0' with repeatCount
                onVisibleChanged: if(visible) text = '0/'+taskDataMap['repeat']
                font.family: Constants.appFont
                font.pixelSize: 8
                color: Constants.taskCheckBoxCC
                Layout.preferredHeight: Constants.buttonHeight
                horizontalAlignment: Text.AlignHCenter
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
        labelLoader.sourceComponent = labelComponent

        //determine which dynamic task elements to load
        if(taskDataMap.hasOwnProperty('isChecked'))
        {
            checkBox.visible = true
        }
        if(taskDataMap.hasOwnProperty('repeat') && taskDataMap['repeat'] > 1)
        {
            repeatLoader.sourceComponent = repeatComponent
        }
    }
}
