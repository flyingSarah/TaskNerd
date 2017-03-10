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

    width: Constants.buttonHeight
    height: Constants.buttonHeight

    border.color: Constants.taskItemBorderColor
    border.width: Constants.taskItemBorderWidth
    color: checked ? Constants.taskCheckBoxCC : Constants.taskCheckBoxUC

    MouseArea
    {
        anchors.fill: parent
        onClicked: {
            checked = !checked
            checkBox.focus = true
        }
    }
}
