import QtQuick 2.3
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1
import QtQml.Models 2.1

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
            implicitWidth: 10
            implicitHeight: 26
            Rectangle {
                color: 'transparent'
                border.color: 'gray'
                border.width: 1
                anchors.fill: parent
                anchors.margins: 2
            }
        }
        scrollBarBackground: Item {
            implicitWidth: 10
            implicitHeight: 26
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
