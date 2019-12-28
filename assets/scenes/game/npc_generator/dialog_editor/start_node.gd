extends MyGraphNode


var port_names_right = ['', 'talks']

func _ready():
	self.type = 'start'

func export(cons=false):
	var data = .export()
	return data