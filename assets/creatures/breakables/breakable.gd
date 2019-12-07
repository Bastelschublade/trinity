extends Creature
class_name Breakable

var fence_res = preload('res://assets/objects/fences/wood/WoodFenceDark.tscn')
var broken_fence_res = preload('res://assets/objects/fences/wood/WoodFenceDarkBroken.tscn')

func _ready():
	pass

func _die():
	#print('BREAKABLE BROKEN')
	for c in self.get_children():
		#print('child')
		c.queue_free()
	var broken_fence = broken_fence_res.instance()
	self.add_child(broken_fence)
	# TODO: play sound
	# TODO: enable respawn timer
