import QtQuick 2.3
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Item
{
    id: taskItem

    property var modelRef

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
                    parent.checkBoxChecked = !parent.checkBoxChecked
                    modelRef.setRecord(index, "isChecked", parent.checkBoxChecked)
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

            TextEdit
            {
                property  string initialText: label

                anchors.fill: parent
                anchors.leftMargin: 5
                verticalAlignment: Text.AlignVCenter

                color: Constants.taskLabelTextColor

                text: initialText
                font.family: Constants.appFont
                font.pixelSize: Constants.appFontSize

                onTextChanged: {
                    label = text
                }
            }
        }

        Item
        {
            width: Constants.taskRowRightSpacing
            height: Constants.buttonHeight
        }
    }
}
