extends MyGraphNode


onready var box = self.get_node('MarginContainer')
onready var box_pady = self.get('rect_min_size').y - box.get('rect_min_size').y


func _ready():
	pass


func _on_TalkNode_resize_request(new_minsize):
	var dy = new_minsize.y - get_minimum_size().y
	box.set('rect_min_size', Vector2(box.get('rect_min_size').x, box.get('rect_min_size').y+dy))
	self.set('rect_min_size', new_minsize)
	self.set('rect_size', new_minsize)



