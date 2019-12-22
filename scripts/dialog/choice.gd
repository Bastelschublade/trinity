extends Node
#class_name DialogChoice2

export(String) var answer
export(bool) var disabled # test
export(int, 'Hide', 'Disable', 'Unbind') var condition_fail = 0
export(bool) var exit = false
export(NodePath) var next_view 

func _ready():
	pass