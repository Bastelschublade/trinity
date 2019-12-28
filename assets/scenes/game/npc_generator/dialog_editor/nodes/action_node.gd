extends MyGraphNode

var port_names_right = []

func _ready():
	self.type = 'action'

func export(cons=false):
	var data = .export()
	return data