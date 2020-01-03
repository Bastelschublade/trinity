extends HBoxContainer

func _ready():
	pass


func _on_OptionButton_item_selected(id):
	#print('Selected: ', id)
	pass


func _on_x_pressed():
	self.queue_free()
