import QtQuick 2.3
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Rectangle
{
    //TODO: should aslo allow icon images instead of characters
    property string buttonText

    property string bgColor: Constants.windowBgColor
    property string cColor: Constants.selectColor
    property int fontSize: Constants.appFontSize
    property bool isMomentary: true

    signal buttonClick(bool isChecked) //momentary buttons can ignore the isChecked parameter when using this signal

    color: bgColor
    border.color: Constants.borderColor
    border.width: Constants.borderWidth

    Text
    {
        id: toolBarText
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: buttonText

        font.family: Constants.appFont
        font.pixelSize: fontSize
        color: Constants.buttonTextColor
    }

    MouseArea
    {
        id: toolBarBehavior

        property bool checked: false

        anchors.fill: parent

        //these three signals are listed here in the order they are executed
        onPressed: isMomentary ? checked = true : checked = !checked
        onReleased: if(isMomentary) checked = false
        onClicked: buttonClick(checked)

        onCheckedChanged: {
            if(checked)
            {
                parent.color = cColor
                toolBarText.color = bgColor
            }
            else
            {
                parent.color = bgColor
                toolBarText.color = Constants.buttonTextColor
            }
        }
    }

    function reset()
    {
        toolBarBehavior.checked = false
    }
}
