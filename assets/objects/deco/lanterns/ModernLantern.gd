extends GameObject

export(bool) var on

var on_mat = preload('res://assets/materials/WindowLight.material')
var off_mat = preload('res://assets/materials/DefaultFantasy.material')
onready var mesh = get_node('Body/Mesh')

func _ready():
	self.interact()


func interact():
	on = !on
	if on:
		object_tooltip = 'Ausschalten'
		mesh.set('material/2', on_mat)
	else:
		object_tooltip = 'Einschalten'
		mesh.set('material/2', off_mat)
	