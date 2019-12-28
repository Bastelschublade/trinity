extends MyGraphNode

func _ready():
	self.type = 'quest'

var port_names_right = ['answers', 'actions']

func export(cons=false):
	var data = .export()
	data['alias'] = get_node('HBoxContainer/LineEdit').text
	data['text'] = get_node('Text/TextEdit').text
	return data