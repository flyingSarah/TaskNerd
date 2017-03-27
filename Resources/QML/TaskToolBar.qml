import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    id: mainItem

    //regular tool bar signals
    signal editButtonClicked()
    signal addButtonClicked()
    signal menuButtonClicked(bool isChecked)

    //edit mode signals
    signal editModeCancelClicked()

    height: Constants.buttonHeight

    // ---------------------------------------------------------------- Load States
    Loader
    {
        id: toolBarLoader
        anchors.fill: parent
    }

    states: [
        State
        {
            name: Constants.viewModes[0]
            PropertyChanges
            {
                target: toolBarLoader
                sourceComponent: toolBar
            }
        },
        State
        {
            name: Constants.viewModes[1]
            PropertyChanges
            {
                target: toolBarLoader
                sourceComponent: editModeCancelButton
            }
        },
        State
        {
            name: Constants.viewModes[2]
            PropertyChanges
            {
                target: mainItem
                visible: false
            }
        }
    ]

    // ---------------------------------------------------------------- Tool Bar

    Component
    {
        id: toolBar

        RowLayout
        {
            spacing: Constants.tabBarSpacing

            // ---------------------------------------------------------------- Tool Buttons
            ToolBarButton
            {
                Layout.preferredHeight: Constants.buttonHeight
                Layout.preferredWidth: Constants.buttonHeight
                buttonText: "e"
                onButtonClick: editButtonClicked()
            }

            ToolBarButton
            {
                Layout.preferredHeight: Constants.buttonHeight
                Layout.preferredWidth: Constants.buttonHeight
                buttonText: "+"
                onButtonClick: addButtonClicked()
            }

            ToolBarButton
            {
                Layout.preferredHeight: Constants.buttonHeight
                Layout.preferredWidth: Constants.buttonHeight
                buttonText: "..."
                isMomentary: false
                onButtonClick: menuButtonClicked(isChecked)
            }
            Component.onCompleted: updatePos(children.length)
        }
    }

    // ---------------------------------------------------------------- Cancel Button for Edit Mode
    Component
    {
        id: editModeCancelButton

        ToolBarButton
        {
            Layout.preferredHeight: Constants.buttonHeight
            Layout.preferredWidth: Constants.buttonHeight
            buttonText: 'cancel'
            onButtonClick: {
                editModeCancelClicked()
            }
        }
    }

    Component.onCompleted: state = Constants.viewModes[0]

    function updatePos(numToolItems)
    {
        //these must be set after numToolItems is defined
        width = (Constants.buttonHeight + Constants.taskRowSpacing) * numToolItems
        Layout.alignment = Qt.AlignRight
    }
}


