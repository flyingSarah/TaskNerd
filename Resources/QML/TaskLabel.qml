import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

import com.swhitley.models 1.0

import "Constants.js" as Constants

TextField
{
    id: textBox

    anchors.fill: parent

    style: TextFieldStyle {
        background: Rectangle {
            color: Constants.taskLabelBgColor
            border.color: Constants.taskItemBorderColor
            border.width: Constants.taskItemBorderWidth
        }
    }

    verticalAlignment: Text.AlignVCenter

    font.family: Constants.appFont
    font.pixelSize: Constants.appFontSize
    textColor: Constants.taskCheckBoxCC

    maximumLength: Constants.taskLabelMaxChars
    placeholderText: 'new task...'

    onEditingFinished: textBox.focus = false

    Keys.onPressed: {
        if(event.key === Qt.Key_Tab)
        {
            editingFinished()
        }
    }

    //allows the text box to be auto selected after adding a new task
    Component.onCompleted: {
        if(visible)
        {
            forceActiveFocus()
        }
    }

    //fixes a bug causing an out-of-view textbox to continue receiving text updates
    onVisibleChanged: {
        if(!visible)
        {
            focus = false
        }
    }
}
