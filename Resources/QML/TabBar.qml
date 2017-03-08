import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: bottomRow

    property int selectedTabIndex: Constants.tabInitIndex
    property int numOfItemsToDelete: 0
    property int numOfItemsToArchive: 0

    signal deleteButtonClicked()
    signal archiveButtonClicked()

    Layout.fillWidth: true
    height: Constants.buttonHeight

    // ---------------------------------------------------------------- Load States
    Loader
    {
        id: tabBarLoader
    }

    states: [
        State
        {
            name: Constants.viewModes[0]
            PropertyChanges
            {
                target: tabBarLoader
                sourceComponent: tabBar
                anchors.fill: bottomRow
            }
        },
        State
        {
            name: Constants.viewModes[1]
            PropertyChanges
            {
                target: tabBarLoader
                sourceComponent: editModeButtons
                anchors.fill: bottomRow
            }
        }
    ]

    // ---------------------------------------------------------------- Tab Bar

    Component
    {
        id: tabBar

        Rectangle
        {
            color: Constants.windowBgColor

            RowLayout
            {
                id: layout
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

                    // ---------------------------------------------------------------- Task Type Buttons
                    TabRadioButton
                    {
                        id: radioButton
                        text: taskTabInfo.titles()[index]
                        radioGroup: tabBarGroup
                        buttonIndex: index

                        height: Constants.buttonHeight
                        Layout.minimumWidth: 70
                        Layout.alignment: Qt.AlignCenter
                        Layout.fillWidth: true

                        onSelected: selectedTabIndex = tabIndex

                        Component.onCompleted: {
                            //this is where the first tab in the view is initialized
                            //TODO: instead of this being a constant, I should make this a persistent value
                            if(index == selectedTabIndex)
                            {
                                radioGroup.selected = radioButton
                                selected(index)
                            }
                        }
                    }
                }
            }
        }
    }

    // ---------------------------------------------------------------- Delete Button for Delete Mode
    Component
    {
        id: editModeButtons

        RowLayout
        {
            spacing: Constants.tabBarSpacing

            ToolBarButton
            {
                Layout.fillWidth: true
                buttonText: 'Delete ' + numOfItemsToDelete + ' Tasks'
                bgColor: Constants.menuColor
                onButtonClick: deleteButtonClicked()
            }

            ToolBarButton
            {
                Layout.fillWidth: true
                buttonText: 'Archive ' + numOfItemsToArchive + ' Tasks'
                bgColor: Constants.menuColor
                onButtonClick: archiveButtonClicked()
            }
        }


    }

    Component.onCompleted: state = Constants.viewModes[0]
}
