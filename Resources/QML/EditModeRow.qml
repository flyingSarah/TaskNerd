import QtQuick 2.3
import QtQuick.Layouts 1.1

import com.swhitley.models 1.0

import "Constants.js" as Constants

Item
{
    signal deleteThisRow(bool doDelete)
    signal archiveThisRow(bool doArchive)

    Layout.fillHeight: true
    width: (editModeRow.children.length) * (Constants.editModeButtonWidth + editModeRow.spacing)

    RowLayout
    {
        id: editModeRow
        spacing: Constants.editModeSpacing

        ToolBarButton
        {
            id: archiveButton
            width: Constants.editModeButtonWidth
            height: Constants.editModeButtonHeight
            bgColor: Constants.menuColor
            buttonText: 'a'
            border.width: Constants.editModeBorderWidth
            isMomentary: false
            onButtonClick: archiveThisRow(isChecked)
        }

        ToolBarButton
        {
            width: Constants.editModeButtonWidth
            height: Constants.editModeButtonHeight
            bgColor: Constants.menuColor
            buttonText: 'e'
            border.width: Constants.editModeBorderWidth
        }

        ToolBarButton
        {
            id: deleteButton
            width: Constants.editModeButtonWidth
            height: Constants.editModeButtonHeight
            bgColor: Constants.menuColor
            buttonText: 'x'
            border.width: Constants.editModeBorderWidth
            isMomentary: false
            onButtonClick: deleteThisRow(isChecked)
        }
    }

    function reset()
    {
        archiveButton.reset()
        deleteButton.reset()
    }
}
