import QtQuick 2.3
import QtQuick.Layouts 1.1

import "Constants.js" as Constants

Column
{
    width: Constants.menuWidth
    visible: false

    height: parent.height

    Rectangle
    {
        height: parent.height
        width: parent.width
        color: Constants.windowBgColor

        Repeater
        {
            model: Constants.menuItems

            ToolBarButton
            {
                width: parent.width
                bgColor: Constants.menuColor
                fontSize: Constants.menuFontSize
                buttonText: modelData
                border.color: Constants.windowBgColor
                height: Constants.taskRowHeight
            }
        }
    }
}
