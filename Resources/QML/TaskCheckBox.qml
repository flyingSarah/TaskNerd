import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

//TODO: this will need to change into some sort of check box icon eventually
Rectangle
{
    id: checkBox

    property bool checked
    property string textColor: Constants.taskLabelTextColor

    width: Constants.buttonHeight
    height: Constants.buttonHeight

    border.color: Constants.borderColor
    border.width: Constants.borderWidth
    color: Constants.windowBgColor

    Text
    {
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: checked ? '√' : ''
        font.family: 'Marker Felt'
        font.pixelSize: Constants.appFontSize+6
        color: textColor
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: {
            checked = !checked
            checkBox.focus = true
        }
    }
}
