import QtQuick 2.3

Rectangle
{
	id: radioButton
				
	property string text: 'Button'
	property int buttonIndex: -1
    property RadioGroup radioGroup
	
	signal selected(int tabIndex)
			
	border.color: 'gray'
	border.width: 2
	color: radioGroup.selected === radioButton ? 'gray' : 'transparent'
			
	Text
	{
		id: radioButtonLabel
		text: radioButton.text
		font.family: 'Avenir'
		font.bold: true
		font.pixelSize: 14
		color: radioGroup.selected === radioButton ? 'lightgray' : 'gray'
		anchors.centerIn: parent
	}
	
	MouseArea
	{
		id: radioButtonMouseArea
		anchors.fill: parent
		onClicked: radioButton.radioGroup.selected = radioButton, radioButton.selected(radioButton.buttonIndex)
	}
}
