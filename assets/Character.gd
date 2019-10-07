extends KinematicBody


var velocity = Vector3()
var gravity = -9.8
var camera

var SPEED = 6
var ACCELERATION = 3
var DE_ACCELERATION = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	print('Character ready!')
	camera = get_node('../Camera').get_global_transform()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	print('update')


func _physics_process(delta):
	print('physics update')
	var dir = Vector3()
	if Input.is_action_pressed('move_fw'):
		dir += -camera.basis[2]
	if Input.is_action_pressed('move_bw'):
		dir += camera.basis[2]
	if Input.is_action_pressed('move_l'):
		dir += -camera.basis[0]
	if Input.is_action_pressed('move_r'):
		dir += camera.basis[0]
		
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y = delta * gravity
	
	var hv = velocity
	hv.y = 0
	var new_pos = dir * SPEED
	var accel = DE_ACCELERATION
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))