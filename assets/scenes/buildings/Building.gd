extends Spatial

onready var roof = get_node('Roof')
onready var walls = get_node('Walls')


func _ready():
	self.set_process(false)


func _on_Area_body_entered(body):
	if body is Player:
		print('player entered building')
		roof.set_visible(false)
		self.set_process(true)


func _on_Area_body_exited(body):
	if body is Player:
		print('player left building')
		roof.set_visible(true)
		self.set_process(false)
		for c in walls.get_children():
			c.set_visible(true)


func _process(delta):
	var camdir = Global.player.camera.basis.z  # cam facing in z
	var buildx = self.get_global_transform().basis.x  # front facing in x
	var buildz = self.get_global_transform().basis.z  # right facing in z
	var frontview = - camdir.dot(buildx)   # view from front is in minus x (see 3d model)
	var rightview = - camdir.dot(buildz)   # view from right is in minus z
	walls.get_node('Front').set_visible(frontview >= 0)
	walls.get_node('Back').set_visible(frontview <= 0)
	walls.get_node('Left').set_visible(rightview >= 0)
	walls.get_node('Right').set_visible(rightview <= 0)