extends Control

func _ready():
	get_node('TabContainer').set('current_tab', 4)


func _on_TextureButton_pressed():
	self.set_visible(false)
