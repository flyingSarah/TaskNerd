import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: taskItem

    property var modelRef
    property var taskDataMap: {"isChecked": isChecked, "label": label}

    implicitWidth: parent.width
    implicitHeight: Constants.taskRowHeight

    RowLayout
    {
        anchors.verticalCenter: parent.verticalCenter
        spacing: Constants.taskRowSpacing

        width: parent.width
        height: parent.height

        Item
        {
            width: Constants.taskRowLeftSpacing
            height: Constants.buttonHeight
        }

        Rectangle
        {
            id: checkBox

            property bool checkBoxChecked: isChecked

            Layout.preferredWidth: Constants.buttonHeight
            Layout.preferredHeight: Constants.buttonHeight

            border.color: Constants.taskItemBorderColor
            border.width: Constants.taskItemBorderWidth
            color: checkBoxChecked ? Constants.taskCheckBoxCC : Constants.taskCheckBoxUC

            MouseArea
            {
                anchors.fill: parent
                onClicked: {
                    checkBox.checkBoxChecked = !checkBox.checkBoxChecked
                    checkBox.focus = true
                    taskDataMap["isChecked"] = checkBox.checkBoxChecked
                    modelRef.setRecord(index, taskDataMap)
                }
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.minimumWidth: 50
            Layout.maximumWidth: 16000
            Layout.preferredHeight: Constants.buttonHeight

            color: Constants.taskLabelBgColor

            border.color: Constants.taskItemBorderColor
            border.width: Constants.taskItemBorderWidth

            TextInput
            {
                id: textBox

                property  string initialText: label

                anchors.fill: parent
                anchors.leftMargin: 5
                verticalAlignment: Text.AlignVCenter

                color: Constants.taskLabelTextColor

                text: initialText
                font.family: Constants.appFont
                font.pixelSize: Constants.appFontSize

                selectByMouse: true
                maximumLength: 75

                onTextChanged: {
                    if(text != label)
                    {
                        taskDataMap["label"] = text
                        modelRef.setRecord(index, taskDataMap)
                    }
                }

                onEditingFinished: {
                    textBox.focus = false
                }

                Keys.onPressed: {
                    if(event.key === Qt.Key_Tab)
                    {
                        editingFinished()
                    }
                }
            }
        }

        Item
        {
            width: Constants.taskRowRightSpacing
            height: Constants.buttonHeight
        }
    }

    Component.onCompleted: textBox.forceActiveFocus()
}
