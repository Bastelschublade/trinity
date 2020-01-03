extends Creature
class_name Breakable

export(PackedScene) var default_body
export(PackedScene) var broken_body
#var fence_res = preload('res://assets/objects/fences/wood/WoodFenceDark.tscn')
#var broken_fence_res = preload('res://assets/objects/fences/wood/WoodFenceDarkBroken.tscn')


func _ready():
	pass


func die():
	print('BREAKABLE BROKEN')
	for c in self.get_children():
		#print('child')
		c.queue_free()
	self.add_child(broken_body.instance())
	# TODO: play sound
	# TODO: enable respawn timer
