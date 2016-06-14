import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

Item
{
    id: item

    signal selectedTabButton(int tabIndex)

    Rectangle
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        anchors.fill: parent
        color: 'lightgray'

        RowLayout
        {
            id: layout
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.fill: parent
            spacing: 10

            property var tabNames: [ "All Tasks", "Daily Tasks", "Weekly Tasks", "One Off Tasks" ]
            property real numOfTabs: tabNames.length

            RadioGroup
            {
                id: tabBarGroup
            }

            Repeater
            {
                model: layout.numOfTabs

                TabRadioButton
                {
                    text: layout.tabNames[index]
                    radioGroup: tabBarGroup
                    buttonIndex: index

                    height: 22
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 400
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true

                    onSelected: item.selectedTabButton(tabIndex)
                }
            }
        }
    }
}
