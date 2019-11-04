extends Camera


# Declare member variables here. Examples:
export var distance = 5.0
export var height = 2.0
export var rotation_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	set_as_toplevel(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,0)
	var offset = pos - target
	
	offset = offset.normalized()*distance
	
	# rotate offset 
	#rotate in Y axis
	#var m3 = Basis()
	#m3 = m3.rotated( Vector3(0,1,0), PI/2 )
	var angle = rotation_speed * delta
	if Input.is_action_pressed('rotate_camera_right'):
		offset = offset.rotated(Vector3(0,1,0), angle)
	if Input.is_action_pressed('rotate_camera_left'):
		offset = offset.rotated(Vector3(0,1,0), -angle)
	offset.y = height
	pos = target + offset
	
	look_at_from_position(pos, target, up)