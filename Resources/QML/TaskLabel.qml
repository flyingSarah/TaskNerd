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
        placeholderTextColor: Constants.selectColor
        background: Rectangle {
            color: Constants.windowBgColor
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
                        color: Qt.rgba(1,1,1,0.07*modelData)//Qt.rgba(0.4-0.4*modelData,0.2,0.3,1)//Qt.rgba(0.65,0.2,0.42,0.8 - 0.8*modelData)
                        width: (progressRow.width - (progressRow.spacing*progressRow.modelCount)) / progressRow.modelCount
                        height: progressRow.height
                    }
                }
            }
            Rectangle{width:parent.width; height: 1; y: parent.height+1; color: '#1affffff'}
        }
    }

    font.family: Constants.appFont
    font.pixelSize: Constants.appFontSize
    textColor: Constants.taskLabelTextColor

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
