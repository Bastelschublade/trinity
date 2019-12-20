extends Spatial

export(NodePath) var cut_ground


onready var roof = get_node('Roof')
onready var walls = get_node('Walls')
onready var world = get_node('/root/World')
onready var ground_node = get_node(cut_ground).get_node('StaticBody/Mesh')


func _ready():
	self.set_process(false)
	
	print('WORLD: ', ground_node)
	var mesh_faces = ground_node.mesh.get_faces()
	for i in range(len(mesh_faces)):
		mesh_faces.set(i, Vector3(0,0,0))


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