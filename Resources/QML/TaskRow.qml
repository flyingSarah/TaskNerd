import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: taskItem

    //Layout.minimumHeight: Constants.taskRowHeight
    //Layout.fillWidth: true

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
            onVisibleChanged: if(visible) setTaskColor()
        }

        //--------------------------------------------------------------- Check Box

        TaskCheckBox
        {
            id: checkBox
            visible: false
            onVisibleChanged: if(visible) checked = isChecked
            onCheckedChanged: taskModel.setDataValue(index, 'isChecked', checked)

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
                text: label
                onVisibleChanged: if(visible) text = label
                onTriggerSetData: taskModel.setDataValue(index, 'label', text)
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
                text: '0/'+repeat //TODO: replace the '0' with repeatCount
                onVisibleChanged: if(visible) text = '0/'+repeat
                font.family: Constants.appFont
                font.pixelSize: 8
                color: Constants.taskCheckBoxCC
                Layout.preferredHeight: Constants.buttonHeight
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Component.onCompleted: {
        labelLoader.sourceComponent = labelComponent

        if(taskModel.parameterNames().indexOf('priority') > -1)
        {
            setTaskColor()
        }

        if(taskModel.parameterNames().indexOf('isChecked') > -1)
        {
            checkBox.visible = true
        }

        if(taskModel.parameterNames().indexOf('repeat') > -1)
        {
            repeatLoader.sourceComponent = repeatComponent
        }
    }

    function setTaskColor()
    {
        taskColor.color = Constants.taskColors[priority][difficulty]
    }
}
