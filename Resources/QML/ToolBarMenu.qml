import QtQuick 2.3

import "Constants.js" as Constants

Column
{
    width: Constants.menuWidth
    visible: false

    Repeater
    {
        model: Constants.menuItems

        ToolBarButton
        {
            width: parent.width
            bgColor: Constants.menuColor
            border.color: Constants.menuBC
            fontSize: Constants.menuFontSize
            charForIcon: modelData
        }
    }
}
