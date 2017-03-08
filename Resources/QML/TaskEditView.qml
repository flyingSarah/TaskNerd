import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Item
{
    property var taskMap
    property int taskRow

    Layout.fillHeight: true
    Layout.fillWidth: true

    Loader
    {
        id: editViewLoader
        anchors.fill: parent
    }

    Component
    {
        id: editViewComponent

        Rectangle
        {
            id: editView
            anchors.fill: parent

            Component.onCompleted: loadTaskElements()
            color: Constants.windowBgColor
            border.width: Constants.taskItemBorderWidth

            Item
            {
                anchors.fill: parent
                anchors.margins: 10

                GridLayout
                {
                    width: parent.width
                    columnSpacing: parent.anchors.margins
                    rowSpacing: columnSpacing
                    columns: 2

                    // ---------------------------------------------------------------- Task Title

                    Text
                    {
                        text: 'Title:'
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize
                        color: Constants.taskCheckBoxCC
                    }

                    TaskLabel
                    {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 50
                        Layout.preferredHeight: Constants.editViewRowHeight
                        text: taskMap['label']
                        font.pixelSize: Constants.menuFontSize
                        onTextChanged: taskMap['label'] = text
                    }

                    // ---------------------------------------------------------------- Priority Label

                    Text
                    {
                        text: 'Priority:'
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize
                        color: Constants.taskCheckBoxCC
                    }

                    RowLayout
                    {
                        spacing: Constants.tabBarSpacing

                        RadioGroup
                        {
                            id: priorityGroup
                        }

                        Repeater
                        {
                            model: Constants.priorityOptions

                            // ---------------------------------------------------------------- Priority Choices
                            TabRadioButton
                            {
                                id: priorityRadioButton
                                text: modelData
                                fontSize: Constants.menuFontSize
                                radioGroup: priorityGroup
                                buttonIndex: index

                                height: Constants.editViewRowHeight
                                Layout.minimumWidth: 10
                                Layout.alignment: Qt.AlignCenter
                                Layout.fillWidth: true

                                onSelected: {
                                    taskMap['priority'] = tabIndex
                                    editView.loadColor()
                                }

                                Component.onCompleted: {
                                    //this is where the first tab in the view is initialized
                                    //TODO: instead of this being a constant, I should make this a persistent value
                                    if(index === taskMap['priority'])
                                    {
                                        radioGroup.selected = priorityRadioButton
                                        selected(index)
                                    }
                                }
                            }
                        }
                    }

                    // ---------------------------------------------------------------- Difficulty Label

                    Text
                    {
                        text: 'Difficulty:'
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize
                        color: Constants.taskCheckBoxCC
                    }

                    RowLayout
                    {
                        spacing: Constants.tabBarSpacing

                        RadioGroup
                        {
                            id: difficultyGroup
                        }

                        Repeater
                        {
                            model: Constants.difficultyOptions

                            // ---------------------------------------------------------------- Difficulty Choices
                            TabRadioButton
                            {
                                id: difficultyRadioButton
                                text: modelData
                                fontSize: Constants.menuFontSize
                                radioGroup: difficultyGroup
                                buttonIndex: index

                                height: Constants.editViewRowHeight
                                Layout.minimumWidth: 10
                                Layout.alignment: Qt.AlignCenter
                                Layout.fillWidth: true

                                onSelected: {
                                    taskMap['difficulty'] = tabIndex
                                    editView.loadColor()
                                }

                                Component.onCompleted: {
                                    //this is where the first tab in the view is initialized
                                    //TODO: instead of this being a constant, I should make this a persistent value
                                    if(index === taskMap['difficulty'])
                                    {
                                        radioGroup.selected = difficultyRadioButton
                                        selected(index)
                                    }
                                }
                            }
                        }
                    }

                    // ---------------------------------------------------------------- Repeat Value

                    Text
                    {
                        id: repeatLabel
                        text: 'Repeat:'
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize
                        color: Constants.taskCheckBoxCC
                        visible: false
                    }

                    Loader
                    {
                        id: repeatLoader
                    }

                    Component
                    {
                        id: repeatComponent

                        TaskLabel
                        {
                            Layout.minimumWidth: 10
                            Layout.preferredHeight: Constants.editViewRowHeight
                            text: taskMap['repeat']
                            font.pixelSize: Constants.menuFontSize
                            onTextChanged: taskMap['repeat'] = parseInt(text)
                            validator: IntValidator {
                                bottom: 1
                                top: 999
                            }
                            placeholderText: '1'
                            onAcceptableInputChanged: {
                                if(!acceptableInput) taskMap['repeat'] = 1 //if the text box is empty set the taskMap to 1
                                if(text != '' && !acceptableInput) //if the text box is empty and also contains non-numeric characters, change the text field to 1
                                {
                                    text = '1'
                                    //TODO: take out log msg
                                    console.log("weird event in the edit view repeat text field:\n
                                                 ... a value other than a number was entered")
                                }
                            }

                            //TODO: I need to add some more conveniences to this number box
                            //... there should be able to inc up and down using mouse or keyboard
                            //... perhaps there's a better way to deal with an empty box as well, etc...
                        }
                    }
                }
            }

            function loadTaskElements()
            {
                //always load these elements
                loadColor()

                //determine which dynamic task elements to load
                if(taskMap.hasOwnProperty('repeat'))
                {
                    repeatLabel.visible = true
                    repeatLoader.sourceComponent = repeatComponent
                }
            }

            function loadColor()
            {
                editView.border.color = Constants.taskColors[taskMap['priority']][taskMap['difficulty']]
            }
        }
    }

    onVisibleChanged: {
        visible ? editViewLoader.sourceComponent = editViewComponent : editViewLoader.sourceComponent = undefined
    }
}
