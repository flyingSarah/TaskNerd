import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import "Constants.js" as Constants

Item
{
    id: item

    signal selectedTabButton(int tabIndex)

    Rectangle
    {
        Layout.fillHeight: true
        Layout.fillWidth: true
        anchors.fill: parent
        color: Constants.windowBgColor

        RowLayout
        {
            id: layout
            Layout.fillHeight: true
            Layout.fillWidth: true
            anchors.fill: parent
            spacing: Constants.tabBarSpacing

            property var tabNames: [ Constants.tabName1, Constants.tabName2 ]
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

                    height: Constants.buttonHeight
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
