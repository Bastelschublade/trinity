extends MyGraphNode


onready var box = self.get_node('MarginContainer')
onready var box_pady = self.get('rect_min_size').y - box.get('rect_min_size').y

#var port_names_left = ['froms']
var port_names_right = ['answers']

func _ready():
	self.type = 'talk'


func _on_TalkNode_resize_request(new_minsize):
	var dy = new_minsize.y - get_minimum_size().y
	box.set('rect_min_size', Vector2(box.get('rect_min_size').x, box.get('rect_min_size').y+dy))
	self.set('rect_min_size', new_minsize)
	self.set('rect_size', new_minsize)



func export(cons=false):
	var data = .export(cons)
	data['text'] = get_node('MarginContainer/VBoxContainer/Text').text
	return data