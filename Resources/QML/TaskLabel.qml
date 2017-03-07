import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Rectangle
{
    property string labelText

    color: Constants.taskLabelBgColor

    border.color: Constants.taskItemBorderColor
    border.width: Constants.taskItemBorderWidth

    TextInput
    {
        id: textBox

        anchors.fill: parent
        anchors.leftMargin: Constants.taskLabelLeftMargin
        verticalAlignment: Text.AlignVCenter

        color: Constants.taskLabelTextColor

        text: labelText
        font.family: Constants.appFont
        font.pixelSize: Constants.appFontSize

        selectByMouse: true
        maximumLength: Constants.taskLabelMaxChars

        onTextChanged: labelText = text
        onEditingFinished: textBox.focus = false

        Keys.onPressed: {
            if(event.key === Qt.Key_Tab)
            {
                editingFinished()
            }
        }
    }

    //allows the text box to be auto selected after adding a new task
    Component.onCompleted: {
        if(visible)
        {
            textBox.forceActiveFocus()
        }
    }

    //fixes a bug causing an out-of-view textbox to continue receiving text updates
    onVisibleChanged: {
        if(!visible)
        {
            textBox.focus = false
        }
    }
}
