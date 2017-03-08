import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    //regular tool bar signals
    signal editButtonClicked()
    signal addButtonClicked()
    signal menuButtonClicked(bool isChecked)

    //delete mode signals
    signal cancelButtonClicked()

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
                sourceComponent: cancelButton
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
                buttonText: "e"
                onButtonClick: editButtonClicked()
            }

            ToolBarButton
            {
                buttonText: "+"
                onButtonClick: addButtonClicked()
            }

            ToolBarButton
            {
                buttonText: "..."
                isMomentary: false
                onButtonClick: menuButtonClicked(isChecked)
            }
            Component.onCompleted: updatePos(children.length)
        }
    }

    // ---------------------------------------------------------------- Cancel Button for Delete Mode
    Component
    {
        id: cancelButton

        ToolBarButton
        {
            buttonText: 'cancel'
            bgColor: Constants.menuColor
            onButtonClick: {
                cancelButtonClicked()
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


