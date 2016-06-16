import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

import "Constants.js" as Constants

ScrollView
{
    id: scrollView

    //signal tabTaskCheckChanged(string tab, int task, bool checkBoxState)

    property var tabModel
    property string tabDelegate

    Layout.fillWidth: true
    Layout.fillHeight: true

    frameVisible: true
    highlightOnFocus: true

    style: ScrollViewStyle {
        transientScrollBars: true
        handle: Item {
            //scroll bar handle size & appearance
            //TODO: figure out how to set scroll bar positions and have them appear at the correct
            // .... positions when loaded from the main view (when the app starts they can all start
            // .... from the top position
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
        spacing: -2

        Repeater
        {
            id: taskRepeater
            width: parent.width

            model: tabModel
            delegate: Loader {

                id: taskLoader
                Layout.fillWidth: true
                source: "%1.qml".arg(tabDelegate)

                /*Connections
                {
                    target: taskLoader.item
                    onCheckBoxIsChecked: tabTaskCheckChanged(scrollView.tabDelegate, taskIndex, taskChecked)
                }*/
            }
        }
    }
}
