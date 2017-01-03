import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

ScrollView
{
    id: scrollView

    property string tabDelegate
    property string tabTableName

    Layout.fillWidth: true
    Layout.fillHeight: true

    frameVisible: true
    highlightOnFocus: true

    function addTask()
    {
        taskModel.insertNewRecord()
    }

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
                anchors.margins: 2
            }
        }
        scrollBarBackground: Item {
            implicitWidth: Constants.scrollBarWidth
            implicitHeight: Constants.scrollBarHeight
        }
    }

    ColumnLayout
    {
        id: taskList
        anchors.top: parent.top
        width: scrollView.width - 2
        Layout.fillWidth: true
        spacing: 0

        Repeater
        {
            id: taskRepeater

            property int finCount: 0

            width: parent.width
            model: TaskModel {
                id: taskModel
            }

            delegate: Loader {
                id: taskLoader
                Layout.fillWidth: true
                sourceComponent: TaskRow //having this in a loader prevents errors when saving
                {
                    Layout.fillWidth: true
                    modelRef: taskModel
                }
            }

            Component.onCompleted: {
                taskModel.setupModel(tabTableName)
            }
        }
    }

    //TODO: set scroll bar positions and have them appear at the correct positions when loaded
    // .... from the main view (when the app starts they can all start from the top position

    flickableItem.onContentHeightChanged: {
        //console.log("flickable item content height changed", taskRepeater.finCount, taskRepeater.count)
        if(taskRepeater.finCount == taskRepeater.count)
        {
            //flickableItem.contentY = 300
        }
        taskRepeater.finCount++
    }

    flickableItem.onContentYChanged: {
        //console.log("flickable item content y changed", flickableItem.contentY, flickableItem.contentHeight)
    }

    Keys.onPressed: {
        if(event.key === Qt.Key_S && event.modifiers === Qt.ControlModifier)
        {
            taskModel.submitAll() //TODO: figure out how to also save the other tabs
        }
        if(event.key === Qt.Key_R && event.modifiers === Qt.ControlModifier)
        {
            taskModel.revertAll()
            taskModel.select()
        }
    }
}
