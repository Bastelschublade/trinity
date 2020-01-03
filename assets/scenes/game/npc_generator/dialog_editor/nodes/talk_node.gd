extends MyGraphNode


onready var box = self.get_node('MarginContainer')
onready var box_pady = self.get('rect_min_size').y - box.get('rect_min_size').y

#var port_names_left = ['froms']
var port_names_right = ['answers']

func _ready():
	self.type = 'talk'
	$MarginContainer/VBoxContainer/NodeHeader/TextureButton.connect("pressed", self, "_on_minimize_pressed")
	$MarginContainer/VBoxContainer/NodeHeader/ResizeButton.connect("pressed", self, "_on_show_node_pressed")


func _on_TalkNode_resize_request(new_minsize):
	var dy = new_minsize.y - get_minimum_size().y
	box.set('rect_min_size', Vector2(box.get('rect_min_size').x, box.get('rect_min_size').y+dy))
	self.set('rect_min_size', new_minsize)
	self.set('rect_size', new_minsize)



func export(cons=false):
	var data = .export(cons)
	data['text'] = get_node('MarginContainer/VBoxContainer/Text').text
	return data
	

func _on_minimize_pressed():
	for c in $MarginContainer/VBoxContainer.get_children():
		if c.name == "NodeHeader":
			c.get_node('TextureButton').set_visible(false)
			c.get_node('ResizeButton').set_visible(true)
		else:
			c.set_visible(false)
	#$MarginContainer.set('rect_min_size', Vector2(150, 80))
	#$MarginContainer.set('rect_size', Vector2(150, 80))
	self.set('rect_min_size', Vector2(150, 60))
	self.set('rect_size', Vector2(150, 60))


func _on_show_node_pressed():
	for c in $MarginContainer/VBoxContainer.get_children():
		c.set_visible(true)
	$MarginContainer/VBoxContainer/NodeHeader/TextureButton.set_visible(true)
	$MarginContainer/VBoxContainer/NodeHeader/ResizeButton.set_visible(false)