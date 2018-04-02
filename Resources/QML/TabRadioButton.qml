import QtQuick 2.3

import "Constants.js" as Constants

Rectangle
{
	id: radioButton
				
	property string text: 'Button'
	property int buttonIndex: -1
    property RadioGroup radioGroup
    property int fontSize: Constants.appFontSize

    property string selectColor: Constants.selectColor
	
	signal selected(int tabIndex)
			
    border.color: Constants.borderColor
    border.width: Constants.borderWidth
    color: radioGroup.selected === radioButton ? selectColor : Constants.unselectColor
			
	Text
	{
		id: radioButtonLabel
		text: radioButton.text
        font.family: Constants.appFont
        font.pixelSize: fontSize
        color: radioGroup.selected === radioButton ? Constants.unselectColor : Constants.buttonTextColor
		anchors.centerIn: parent
	}
	
	MouseArea
	{
		id: radioButtonMouseArea
		anchors.fill: parent
        onClicked: radioButton.radioGroup.selected = radioButton, radioButton.selected(radioButton.buttonIndex)
	}
}
