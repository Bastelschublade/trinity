extends GraphNode

export(String) var export_string = 'test'
export(String) var export_string2 = 'test'
var local_variable = 0
var local_variable2 = 0

func _ready():
	print('graph_node created')
	var color = Color(1,1,1)
	set_slot ( 1, true, 0, color, true, 0,  color)
	set_slot ( 2, true, 0, color, true, 0,  color)