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
    signal doneButtonClicked()

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
        },
        State
        {
            name: Constants.viewModes[2]
            PropertyChanges
            {
                target: tabBarLoader
                sourceComponent: doneButton
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
                anchors.fill: parent
                spacing: Constants.tabBarSpacing

                TaskTabInfo
                {
                    id: taskTabInfo
                }

                RadioGroup
                {
                    id: tabBarGroup
                }

                Repeater
                {
                    model: taskTabInfo.taskTableTitles()

                    // ---------------------------------------------------------------- Task Type Buttons
                    TabRadioButton
                    {
                        id: radioButton

                        selectColor: Constants.tabSelectColor
                        border.color: Constants.tabSelectColor

                        text: modelData
                        radioGroup: tabBarGroup
                        buttonIndex: index
                        fontSize: Constants.appMiniFontSize

                        height: Constants.buttonHeight
                        Layout.minimumWidth: 57
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

    // ---------------------------------------------------------------- Delete & Archive Buttons for Edit Mode
    Component
    {
        id: editModeButtons

        RowLayout
        {
            spacing: Constants.tabBarSpacing

            ToolBarButton
            {
                Layout.fillWidth: true
                Layout.preferredHeight: Constants.buttonHeight
                buttonText: 'Archive ' + numOfItemsToArchive + ' Tasks'
                onButtonClick: archiveButtonClicked()
            }

            ToolBarButton
            {
                Layout.fillWidth: true
                Layout.preferredHeight: Constants.buttonHeight
                buttonText: 'Delete ' + numOfItemsToDelete + ' Tasks'
                onButtonClick: deleteButtonClicked()
            }
        }
    }

    // ---------------------------------------------------------------- Done Button for Edit View

    Component
    {
        id: doneButton

        ToolBarButton
        {
            buttonText: 'Done'
            Layout.fillWidth: true
            Layout.preferredHeight: Constants.buttonHeight
            onButtonClick: doneButtonClicked()
        }
    }

    Component.onCompleted: state = Constants.viewModes[0]
}
