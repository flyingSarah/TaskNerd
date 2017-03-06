import QtQuick 2.3
//import QtQuick.Controls 1.1
//import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Rectangle
{
    //TODO: this should be changed into icon images instead of characters
    property string charForIcon

    property string bgColor: Constants.toolBarButtonC
    property int fontSize: Constants.appFontSize
    property bool isMomentary: true

    signal buttonClick(bool isChecked)

    Layout.minimumWidth: Constants.buttonHeight
    height: Constants.buttonHeight

    color: bgColor
    border.color: Constants.taskItemBorderColor
    border.width: Constants.taskItemBorderWidth

    Text
    {
        id: toolBarText
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: charForIcon

        font.family: Constants.appFont
        font.pixelSize: fontSize
        color: Constants.taskLabelTextColor
    }

    MouseArea
    {
        id: toolBarBehavior

        property bool checked: false

        anchors.fill: parent

        onClicked: buttonClick(checked)
        onPressed: isMomentary ? checked = true : checked = !checked
        onReleased: if(isMomentary) checked = false

        onCheckedChanged: {
            if(checked)
            {
                parent.color = Constants.taskLabelTextColor
                toolBarText.color = bgColor
            }
            else
            {
                parent.color = bgColor
                toolBarText.color = Constants.taskLabelTextColor
            }
        }
    }

    function setChecked(isChecked)
    {
        toolBarBehavior.checked = isChecked
    }
}
