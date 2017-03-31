import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

ScrollView
{
    Layout.fillWidth: true
    Layout.fillHeight: true
    visible: false
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
                border.color: Constants.borderColor
                border.width: Constants.borderWidth
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
        onVisibleChanged: checklistTitle.visible = visible

        Item{Layout.preferredHeight: parent.spacing/2}

        Repeater
        {
            id: checklistRepeater
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            model: checklistData

            RowLayout
            {
                id: checklistRow

                spacing: Constants.taskRowSpacing

                Layout.preferredWidth: checklistScrollView.width - checklistColumn.spacing

                Item{Layout.preferredWidth: checklistColumn.spacing/2}

                //--------------------------------------------------------------- Checklist Check Box

                TaskCheckBox
                {
                    id: checkBox
                    checked: modelData['isChecked']
                    height: Constants.editViewRowHeight
                    width: Constants.editViewRowHeight
                    onCheckedChanged: {
                        checklistData[index]['isChecked'] = checked
                        updateChecklistProgress(index, checked)
                        taskModel.setRelatedDataValue(row, 'count', index, 'isChecked', checked)
                    }

                }

                //--------------------------------------------------------------- Checklist Task Label
                TaskLabel
                {
                    text: modelData['label']
                    Layout.fillWidth: true
                    Layout.preferredHeight: Constants.editViewRowHeight
                    font.pixelSize: Constants.appMiniFontSize
                    onTriggerSetData: {
                        checklistData[index]['label'] = text
                        taskModel.setRelatedDataValue(row, 'count', index, 'label', text)
                    }
                }

                //--------------------------------------------------------------- Checklist Task Delete Button
                ToolBarButton
                {
                    Layout.preferredHeight: Constants.editViewRowHeight
                    Layout.preferredWidth: Constants.editViewRowHeight
                    buttonText: 'x'
                    onButtonClick: deleteChecklistItem(index) //console.log("delete checklist row", index)
                    bgColor: 'transparent'
                    border.width: 0
                }

                Item {Layout.preferredWidth: Constants.taskRowMargin}
            }
        }
    }
}
