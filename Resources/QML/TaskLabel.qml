import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

import com.swhitley.models 1.0

import "Constants.js" as Constants

TextField
{
    id: textBox

    property var progress: []

    signal triggerSetData()

    style: TextFieldStyle {
        background: Rectangle {
            color: Constants.taskLabelBgColor
            border.color: Constants.taskItemBorderColor
            border.width: Constants.taskItemBorderWidth

            //TODO: get the stuff below working with task data to show a progress bar
            //... I've already got everything working visually, I just need data to play with
            Row
            {
                id: progressRow

                property real modelCount: textBox.progress.length

                anchors.fill: parent
                anchors.margins: 3
                spacing: 1

                Repeater
                {
                    model: textBox.progress
                    Rectangle
                    {
                        color: Qt.rgba(0.8,0.8,0.8,0.3*modelData+0.2)
                        width: (progressRow.width - (progressRow.spacing*progressRow.modelCount)) / progressRow.modelCount
                        height: progressRow.height
                    }
                }
            }
        }
    }

    font.family: Constants.appFont
    font.pixelSize: Constants.appFontSize
    textColor: Constants.taskCheckBoxCC

    maximumLength: Constants.taskLabelMaxChars
    placeholderText: 'new task...'

    onTextChanged: triggerSetData()
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
