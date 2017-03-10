import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Item
{
    property var taskMap
    property var checklistMap: undefined
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

            color: Constants.windowBgColor
            border.width: Constants.taskItemBorderWidth
            border.color: Constants.taskItemBorderColor

            ColumnLayout
            {
                anchors.fill: parent
                anchors.margins: 5
                spacing: 5

                GridLayout
                {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom
                    columnSpacing: parent.anchors.margins
                    rowSpacing: columnSpacing
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
                        text: taskMap['label']
                        font.pixelSize: Constants.menuFontSize - 2
                        onTextChanged: taskMap['label'] = text
                    }
                }

                // ---------------------------------------------------------------- Checklist

                Repeater
                {
                    id: checklistRepeater
                    Layout.alignment: Qt.AlignTop
                    model: checklistMap
                    visible: false
                    Rectangle{visible: false; color: 'pink'; height: Constants.editViewRowHeight; Layout.fillWidth: true}
                    onVisibleChanged: {
                        for(var i = 0; i < checklistRepeater.count; i++)
                        {
                            checklistRepeater.itemAt(i).visible = visible
                        }
                    }
                }

                GridLayout
                {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    columnSpacing: parent.anchors.margins
                    rowSpacing: columnSpacing
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
                            Layout.minimumWidth: 10
                            height: Constants.editViewRowHeight
                            text: taskMap['repeat']
                            font.pixelSize: Constants.menuFontSize - 2
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
                //determine which dynamic task elements to load
                if(taskMap.hasOwnProperty('priority'))
                {
                    loadColor()
                }
                if(taskMap.hasOwnProperty('repeat'))
                {
                    repeatLabel.visible = true
                    repeatLoader.sourceComponent = repeatComponent
                }
                if(checklistMap !== undefined)
                {
                    checklistRepeater.visible = true
                }
            }

            function loadColor()
            {
                editView.border.color = Constants.taskColors[taskMap['priority']][taskMap['difficulty']]
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
            checklistMap = undefined
            editViewLoader.sourceComponent = undefined
        }
    }

    function populateMaps(tabelMap)
    {
        for(var tabel in tabelMap)
        {
            if(tabelMap.hasOwnProperty(tabel) && tabel.search('Task') > -1)
            {
                taskMap = tabelMap[tabel]
            }
            if(tabelMap.hasOwnProperty(tabel) && tabel.search('Checklist') > -1)
            {
                checklistMap = tabelMap[tabel]
                for(var k in checklistMap)
                {
                    console.log(tabel, "data", taskRow, k, checklistMap[k])
                }
            }
        }
    }
}
