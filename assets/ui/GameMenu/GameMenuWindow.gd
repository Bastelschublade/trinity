extends Control

onready var container = get_node('TabContainer')
func _ready():
	get_node('TabContainer').set('current_tab', 4)


func _on_TextureButton_pressed():
	self.set_visible(false)


func _process(delta):
	if Input.is_action_just_pressed('menu'):
		self.container.set('current_tab', 0)
		self.set_visible(!self.is_visible())
	if Input.is_action_just_pressed('inventory'):
		self.container.set('current_tab', 1)
		self.set_visible(true)
	if Input.is_action_just_pressed('map'):
		self.container.set('current_tab', 2)
		self.set_visible(true)
	if Input.is_action_just_pressed('notes'):
		self.container.set('current_tab', 3)
		self.set_visible(true)
	if Input.is_action_just_pressed('help'):
		self.container.set('current_tab', 4)
		self.set_visible(true)
		