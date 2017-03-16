import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Item
{
    property int row
    property bool hasChecklist

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

                GridLayout
                {
                    Layout.fillWidth: true
                    columnSpacing: parent.spacing
                    rowSpacing: parent.spacing
                    columns: 2

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

                Text
                {
                    id: checklistTitle
                    text: "Checklist (click '+' to add items)"
                    font.family: Constants.appFont
                    font.pixelSize: Constants.menuFontSize
                    color: Constants.taskCheckBoxCC
                    Layout.fillWidth: true
                    visible: false
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.preferredHeight: Constants.editViewRowHeight
                }

                ScrollView
                {
                    id: checklistScrollView
                    visible: false
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    frameVisible: true
                    highlightOnFocus: true

                    // ---------------------------------------------------------------- Scroll Bar
                    style: ScrollViewStyle {
                        transientScrollBars: true
                        handle: Item {
                            //scroll bar handle size & appearance
                            implicitWidth: Constants.scrollBarWidth
                            implicitHeight: Constants.scrollBarHeight
                            Rectangle {
                                color: Constants.scrollBarColor
                                border.color: Constants.scrollBarBC
                                border.width: Constants.scrollBarBW
                                anchors.fill: parent
                                anchors.margins: Constants.scrollBarMargin
                            }
                        }
                        scrollBarBackground: Item {
                            implicitWidth: Constants.scrollBarWidth
                            implicitHeight: Constants.scrollBarHeight
                        }
                    }

                    ColumnLayout
                    {
                        id: checklistColumn
                        anchors.top: parent.top
                        Layout.fillWidth: true
                        spacing: 2

                        Repeater
                        {
                            id: checklistRepeater
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignCenter
                            model: 20//checklistMap
                            Rectangle
                            {
                                color: 'pink';
                                Layout.preferredHeight: Constants.editViewRowHeight;
                                Layout.preferredWidth: checklistScrollView.width - checklistColumn.spacing
                            }
                        }
                        onVisibleChanged: checklistTitle.visible = visible
                    }
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
                                    //this is where the first tab in the view is initialized
                                    //TODO: instead of this being a constant, I should make this a persistent value
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
                                    //this is where the first tab in the view is initialized
                                    //TODO: instead of this being a constant, I should make this a persistent value
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
                        id: repeatLabel
                        text: 'Repeat:'
                        font.family: Constants.appFont
                        font.pixelSize: Constants.menuFontSize - 2
                        color: Constants.taskCheckBoxCC
                        visible: false
                        Layout.preferredWidth: 40
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
                            height: Constants.editViewRowHeight
                            Layout.maximumHeight: Constants.editViewRowHeight
                            text: repeat
                            font.pixelSize: Constants.menuFontSize - 2
                            onTriggerSetData: {
                                var newText = text
                                if(!acceptableInput) newText = '1'
                                if(text != '' && !acceptableInput)
                                {
                                    newText = '1'
                                }
                                taskModel.setDataValue(row, 'repeat', parseInt(newText))
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

            function loadTaskElements()
            {
                //determine which dynamic task elements to load
                if(taskModel.parameterNames().indexOf('priority') > -1)
                {
                    setTaskColor()
                }
                if(taskModel.parameterNames().indexOf('repeat') > -1)
                {
                    repeatLabel.visible = true
                    repeatLoader.sourceComponent = repeatComponent
                }
                if(hasChecklist)
                {
                    checklistScrollView.visible = true
                }
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
