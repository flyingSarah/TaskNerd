import QtQuick 2.3

import "Constants.js" as Constants

Rectangle
{
    //TODO: this should be changed into icon images instead of characters
    property string charForIcon

    signal buttonClick()

    width: Constants.buttonHeight
    height: Constants.buttonHeight

    color: Constants.taskCheckBoxUC
    border.color: Constants.taskItemBorderColor
    border.width: Constants.taskItemBorderWidth

    Text
    {
        id: addButtonText
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: charForIcon

        font.family: Constants.appFont
        font.pixelSize: Constants.appFontSize
        color: Constants.taskLabelTextColor
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: {
            buttonClick()
        }

        onPressed: {
            parent.color = Constants.taskCheckBoxCC
            addButtonText.color = Constants.taskCheckBoxUC
        }

        onReleased: {
            parent.color = Constants.taskCheckBoxUC
            addButtonText.color = Constants.taskLabelTextColor
        }
    }
}
