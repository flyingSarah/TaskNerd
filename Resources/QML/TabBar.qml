import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import com.swhitley.models 1.0

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

            TaskTabInfo
            {
                id: taskTabInfo
            }

            property int numOfTabs: taskTabInfo.countTables()

            RadioGroup
            {
                id: tabBarGroup
            }

            Repeater
            {
                model: layout.numOfTabs

                TabRadioButton
                {
                    id: radioButton
                    text: taskTabInfo.titles()[index]
                    radioGroup: tabBarGroup
                    buttonIndex: index

                    height: Constants.buttonHeight
                    Layout.minimumWidth: 100
                    Layout.maximumWidth: 400
                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true

                    onSelected: item.selectedTabButton(tabIndex)

                    Component.onCompleted: {
                        //this is where the first tab in the view is initialized
                        //TODO: instead of this being a constant, I should make this a persistent value
                        if(index == Constants.tabInitIndex)
                        {
                            radioGroup.selected = radioButton, selected(index)
                        }
                    }
                }
            }
        }
    }
}
