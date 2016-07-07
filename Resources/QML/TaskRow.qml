import QtQuick 2.3
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Item
{
    id: taskItem

    implicitWidth: parent.width
    implicitHeight: Constants.taskRowHeight

    //signal checkBoxIsChecked(int taskIndex, bool taskChecked)

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
            color: isChecked ? Constants.taskCheckBoxCC : Constants.taskCheckBoxUC

            MouseArea
            {
                anchors.fill: parent
                onClicked: isChecked = !isChecked //, taskItem.checkBoxIsChecked(i, parent.checkBoxChecked)
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

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 5
                verticalAlignment: Text.AlignVCenter

                color: Constants.taskLabelTextColor

                text: label
                font.family: Constants.appFont
                font.pixelSize: Constants.appFontSize
            }
        }

        Item
        {
            width: Constants.taskRowRightSpacing
            height: Constants.buttonHeight
        }
    }
}
