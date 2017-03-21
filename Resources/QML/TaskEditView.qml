import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Item
{
    property int row
    property var checklistData

    signal getChecklistData()
    signal updateChecklistProgress(int progressIndex, bool progressValue)
    signal addIndexToChecklistProgress()
    signal deleteIndexFromChecklistProgress(int progressIndex)

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

            color: Constants.windowBgColor
            border.width: Constants.taskItemBorderWidth
            border.color: Constants.taskItemBorderColor

            ColumnLayout
            {
                anchors.fill: parent
                anchors.margins: Constants.windowMargins
                spacing: 5

                RowLayout
                {
                    Layout.fillWidth: true
                    spacing: parent.spacing

                    // ---------------------------------------------------------------- Task Title

                    Text
                    {
                        text: 'Title:'
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize - 2
                        color: Constants.taskCheckBoxCC
                        Layout.preferredWidth: 40
                    }

                    TaskLabel
                    {
                        Layout.fillWidth: true
                        Layout.minimumWidth: 50
                        Layout.preferredHeight: Constants.editViewRowHeight
                        text: label
                        font.pixelSize: Constants.menuFontSize - 2
                        onTriggerSetData: taskModel.setDataValue(row, 'label', text)
                    }
                }

                // ---------------------------------------------------------------- Checklist

                RowLayout
                {
                    id: checklistTitle

                    Layout.fillWidth: true
                    Layout.preferredHeight: Constants.editViewRowHeight

                    visible: false

                    Text
                    {
                        text: "Checklist (click '+' to add items)"
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize
                        color: Constants.taskCheckBoxCC
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredHeight: Constants.editViewRowHeight
                    }

                    ToolBarButton
                    {
                        buttonText: "+"
                        Layout.preferredHeight: Constants.editViewRowHeight
                        Layout.preferredWidth: Constants.editViewRowHeight
                        onButtonClick: addChecklistItem()
                    }
                }

                ChecklistView
                {
                    id: checklistScrollView
                }

                GridLayout
                {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    columnSpacing: parent.spacing
                    rowSpacing: parent.spacing
                    columns: 2

                    // ---------------------------------------------------------------- Priority Label

                    Text
                    {
                        text: 'Priority:'
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize - 2
                        color: Constants.taskCheckBoxCC
                        Layout.preferredWidth: 40
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
                                fontSize: Constants.menuFontSize - 2
                                radioGroup: priorityGroup
                                buttonIndex: index

                                Layout.preferredHeight: Constants.editViewRowHeight
                                Layout.minimumWidth: 10
                                Layout.alignment: Qt.AlignCenter
                                Layout.fillWidth: true

                                onSelected: {
                                    taskModel.setDataValue(row, 'priority', tabIndex)
                                    editView.setTaskColor()
                                }

                                Component.onCompleted: {
                                    if(index === priority)
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
                        font.pixelSize: Constants.menuFontSize - 2
                        color: Constants.taskCheckBoxCC
                        Layout.preferredWidth: 40
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
                                fontSize: Constants.menuFontSize - 2
                                radioGroup: difficultyGroup
                                buttonIndex: index

                                Layout.preferredHeight: Constants.editViewRowHeight
                                Layout.minimumWidth: 10
                                Layout.alignment: Qt.AlignCenter
                                Layout.fillWidth: true

                                onSelected: {
                                    taskModel.setDataValue(row, 'difficulty', tabIndex)
                                    editView.setTaskColor()
                                }

                                Component.onCompleted: {
                                    if(index === difficulty)
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
                        id: goalLabel
                        text: 'Goal:'
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize - 2
                        color: Constants.taskCheckBoxCC
                        visible: false
                        Layout.preferredWidth: 40
                    }

                    Loader
                    {
                        id: goalLoader
                    }

                    Component
                    {
                        id: goalComponent

                        TaskLabel
                        {
                            height: Constants.editViewRowHeight
                            Layout.maximumHeight: Constants.editViewRowHeight
                            text: goal
                            font.pixelSize: Constants.menuFontSize - 2
                            onTriggerSetData: {
                                var newText = text
                                if(!acceptableInput) newText = '1'
                                if(text != '' && !acceptableInput)
                                {
                                    newText = '1'
                                }
                                taskModel.setDataValue(row, 'goal', parseInt(newText))
                            }
                            validator: IntValidator {
                                bottom: 1
                                top: 999
                            }
                            placeholderText: '1'
                            //TODO: I need to add some more conveniences to this number box
                            //... there should be able to inc up and down using mouse or keyboard
                            //... perhaps there's a better way to deal with an empty box as well, etc...
                        }
                    }
                }
            }

            // ---------------------------------------------------------------- Helper Functions

            function loadTaskElements()
            {
                //determine which dynamic task elements to load
                if(taskModel.parameterNames().indexOf('priority') > -1)
                {
                    setTaskColor()
                }
                if(taskModel.parameterNames().indexOf('goal') > -1)
                {
                    goalLabel.visible = true
                    goalLoader.sourceComponent = goalComponent
                }
                if(taskModel.parameterNames().indexOf('count') > -1)
                {
                    checklistScrollView.visible = true
                }
            }

            function populateChecklist()
            {
                getChecklistData()
            }

            function addChecklistItem()
            {
                addIndexToChecklistProgress()
                var success = taskModel.insertNewRelatedRecord(row, 'checklistCount', 'count', taskTabInfo.parameterDefaultMaps()[0], checklistData.length)

                if(success)
                {
                    populateChecklist()
                }

                //when adding a task adjust the scroll area so you can see the added task at the bottom
                var pos = checklistScrollView.flickableItem.contentHeight - checklistScrollView.flickableItem.height
                if(pos > 0)
                {
                    checklistScrollView.flickableItem.contentY = pos
                }
            }

            function deleteChecklistItem(checklistRow)
            {
                deleteIndexFromChecklistProgress(checklistRow)
                taskModel.removeRelatedRow(row, 'checklistCount', 'count', checklistRow, checklistData.length)
                populateChecklist()
            }

            function setTaskColor()
            {
                editView.border.color = Constants.taskColors[priority][difficulty]
            }

            Component.onCompleted: loadTaskElements()
        }
    }

    onVisibleChanged: {
        if(visible)
        {
            editViewLoader.sourceComponent = editViewComponent
        }
        else
        {
            editViewLoader.sourceComponent = undefined
        }
    }
}
