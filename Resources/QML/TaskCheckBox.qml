import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Rectangle
{
    id: checkBox

    property var _taskDataMap
    property bool checkBoxChecked: _taskDataMap['isChecked']

    signal updateTaskDataMap(var taskDataMap_)

    border.color: Constants.taskItemBorderColor
    border.width: Constants.taskItemBorderWidth
    color: checkBoxChecked ? Constants.taskCheckBoxCC : Constants.taskCheckBoxUC

    MouseArea
    {
        anchors.fill: parent
        onClicked: {
            checkBox.checkBoxChecked = !checkBox.checkBoxChecked
            checkBox.focus = true
            _taskDataMap['isChecked'] = checkBox.checkBoxChecked
            updateTaskDataMap(_taskDataMap)
        }
    }
}
