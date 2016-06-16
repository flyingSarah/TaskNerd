import QtQuick 2.3

import "Constants.js" as Constants

Rectangle
{
	id: radioButton
				
	property string text: 'Button'
	property int buttonIndex: -1
    property RadioGroup radioGroup
	
	signal selected(int tabIndex)
			
    border.color: Constants.tabButtonBC
    border.width: Constants.tabButtonBW
    color: radioGroup.selected === radioButton ? Constants.tabButtonSC : Constants.tabButtonUC
			
	Text
	{
		id: radioButtonLabel
		text: radioButton.text
        font.family: Constants.appFont
        font.pixelSize: Constants.appFontSize
        color: radioGroup.selected === radioButton ? Constants.tabButtonSTC : Constants.tabButtonUTC
		anchors.centerIn: parent
	}
	
	MouseArea
	{
		id: radioButtonMouseArea
		anchors.fill: parent
        onClicked: radioButton.radioGroup.selected = radioButton, radioButton.selected(radioButton.buttonIndex)
	}
}
