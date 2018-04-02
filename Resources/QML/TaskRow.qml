import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: taskItem

    property var checklistProgress: []

    //--------------------------------------------------------------- Main Task Row

    RowLayout
    {
        spacing: Constants.taskRowSpacing

        width: parent.width

        Item{Layout.preferredWidth: Constants.taskRowMargin}

        //--------------------------------------------------------------- Priority / Difficulty Indicator

        Text
        {
            id: taskColor

            Layout.preferredWidth: Constants.shapeWidth
            Layout.preferredHeight: Constants.shapeHeight
            font.family: 'Wingdings'
            font.pixelSize: Constants.appMiniFontSize-3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: false
            onVisibleChanged: if(visible && index > -1) setTaskColor()
        }

        //--------------------------------------------------------------- Check Box

        TaskCheckBox
        {
            id: checkBox
            visible: false
            onVisibleChanged: if(visible && index > -1) checked = isChecked
            onCheckedChanged: taskModel.setDataValue(index, 'isChecked', checked)
        }

        ToolBarButton
        {
            //TODO: though this is a momentary switch, it should appear as though it's been checked
            //      ... for a couple of seconds. then it should go back to its 'unchecked' state
            id: counterBox
            visible: false
            Layout.preferredHeight: Constants.buttonHeight
            Layout.preferredWidth: Constants.buttonHeight
            cColor: Constants.selectColor
            onButtonClick: taskModel.setDataValue(index, 'counter', counter+1)
        }

        //--------------------------------------------------------------- Task Label
        Loader
        {
            id: labelLoader

            Layout.fillWidth: true
            Layout.preferredWidth: 50
            Layout.preferredHeight: Constants.buttonHeight
        }

        Component
        {
            id: labelComponent

            TaskLabel
            {
                text: label
                progress: checklistProgress
                onTriggerSetData: taskModel.setDataValue(index, 'label', text)
                Component.onCompleted: text = label
                onVisibleChanged: if(visible && index > -1) text = label
            }
        }

        //--------------------------------------------------------------- Repeat Indicator
        Loader
        {
            id: goalLoader
        }

        Component
        {
            id: goalComponent

            Text
            {
                text: counter+'/'+goal
                onVisibleChanged: {
                    if(visible && index > -1) text = counter+'/'+goal
                }
                font.family: Constants.appFont
                font.pixelSize: Constants.appMiniFontSize
                color: Constants.taskLabelTextColor
                Layout.preferredHeight: Constants.buttonHeight
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    function initTaskRowElements()
    {
        labelLoader.sourceComponent = labelComponent

        if(taskModel.parameterNames().indexOf('priority') > -1)
        {
            taskColor.visible = true
        }

        if(taskModel.parameterNames().indexOf('isChecked') > -1)
        {
            checkBox.visible = true
        }

        if(taskModel.parameterNames().indexOf('goal') > -1)
        {
            goalLoader.sourceComponent = goalComponent
            counterBox.visible = true
        }

        if(taskModel.parameterNames().indexOf('count') > -1)
        {
            //console.log("load row with checklists", checklistCount)
        }
    }

    function setTaskColor()
    {
        taskColor.color = Constants.priorities[priority]
        taskColor.text = Constants.difficulties[difficulty]
        checkBox.textColor = Constants.priorities[priority]
    }

    function updateChecklistProgress(progressIndex, progressValue)
    {
        checklistProgress[progressIndex] = progressValue
        reloadLabel()
    }

    function addIndexToChecklistProgress()
    {
        checklistProgress.push(false)
        reloadLabel()
    }

    function deleteIndexFromChecklistProgress(index)
    {
        checklistProgress.splice(index, 1)
        reloadLabel()
    }

    function reloadLabel()
    {
        labelLoader.sourceComponent = undefined
        labelLoader.sourceComponent = labelComponent
    }
}
