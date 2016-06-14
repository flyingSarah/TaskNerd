import QtQuick 2.3
import QtQuick.Layouts 1.1

Item
{
    id: taskItem

    implicitWidth: parent.width
    implicitHeight: 31

    //signal checkBoxIsChecked(int taskIndex, bool taskChecked)

    RowLayout
    {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 3

        width: parent.width
        height: parent.height

        Item
        {
            width: 0
            height: 26
        }

        Rectangle
        {
            //property bool checkBoxChecked: isChecked

            Layout.preferredWidth: 26
            Layout.preferredHeight: 26

            border.color: 'gray'
            border.width: 2
            color: isChecked ? 'gray' : 'transparent'

            MouseArea
            {
                anchors.fill: parent
                onClicked: isChecked = !isChecked//, taskItem.checkBoxIsChecked(i, parent.checkBoxChecked)
            }
        }

        Rectangle
        {
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            Layout.maximumWidth: 16000
            Layout.preferredHeight: 26

            color: 'white'

            border.color: 'gray'
            border.width: 2

            Text
            {
                anchors.fill: parent
                anchors.leftMargin: 5
                verticalAlignment: Text.AlignVCenter

                color: 'gray'

                text: label
                font.family: 'Avenir'
                font.bold: true
                font.pixelSize: 14
            }
        }

        Item
        {
            width: 7
            height: 26
        }
    }
}
