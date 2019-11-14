extends Camera


# Declare member variables here. Examples:
export var distance = 5.0
export var height = 2.0
export var rotation_speed = 1.0

var mouse_rotation = 0
var last_known_mouse_pos = Vector2(0,0)

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
		
	# starting camera drag
	if Input.is_action_just_pressed("drag_cam"):  
		last_known_mouse_pos = get_viewport().get_mouse_position()
		get_node('/root/Level/Ui/Cursor').set_visible(false)
	# dragging cam
	if Input.is_action_pressed("drag_cam"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		offset = offset.rotated(Vector3(0,1,0), -mouse_rotation*delta/10)
	# free cursor again
	if Input.is_action_just_released("drag_cam"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_viewport().warp_mouse(last_known_mouse_pos)
		get_node('/root/Level/Ui/Cursor').set_visible(true)
		

	offset.y = height
	pos = target + offset
	
	look_at_from_position(pos, target, up)


func _input(event):	
	if Input.is_action_pressed("drag_cam"):
		if event is InputEventMouseMotion:
			# todo hide or change cursor to cam
			mouse_rotation = event.get_relative().x