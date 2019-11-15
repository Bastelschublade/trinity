extends KinematicBody


var velocity = Vector3()
var gravity = -4.6
var camera
var anim_player
var character
var raycast
var target
var blocking = false
var block_timer
var flags = []

var RUN_SPEED = 13
var WALK_SPEED = 1.5
var JUMP_SPEED = 2
var ACCELERATION = 1.5
var DE_ACCELERATION = 5

# equip is array of Items
var slots = ["mainhand", "offhand", "chest", "legs", "boots"]
var equip = {}
var bones = {"mainhand": 'HandR1'}

onready var ui = get_node('/root/Level/Ui')
onready var inventory = ui.get_node('GameMenu/TabContainer/Inventar/Inventory')
onready var arma = get_node('Armature')



# Called when the node enters the scene tree for the first time.
func _ready():
	#print('Character ready!')
	character = get_node('.')
	raycast = get_node('RayCast')
	anim_player = get_node('Armature/AnimationPlayer')
	#equip()
	#print(anim_player)
	block_timer = Timer.new()
	block_timer.connect("timeout", self, '_on_block_timer_timeout')
	get_node('.').add_child(block_timer)
	
	# setup equipment dict
	for s in slots:
		equip[s] = {}
		if bones.get(s, false):
			var kit = BoneAttachment.new()
			kit.set_name(s)
			arma.add_child(kit)
			kit.set_bone_name(bones[s])
			equip[s] = {'kit':kit}


func _physics_process(delta):
	var is_moving = false
	var is_fast = false
	var is_grounded = raycast.is_colliding()
	#print('grounded:', is_grounded)
	#print(is_grounded)
	#print(raycast)
	camera = get_node('target/Camera').get_global_transform()
	#print('physics update')
	var dir = Vector3()
	if Input.is_action_pressed('move_fw') and is_grounded:
		is_moving = true
		dir += -camera.basis[2]
	if Input.is_action_pressed('move_bw') and is_grounded:
		is_moving = true
		dir += camera.basis[2]
	if Input.is_action_pressed('move_l') and is_grounded:
		is_moving = true
		dir += -camera.basis[0]
	if Input.is_action_pressed('move_r') and is_grounded:
		is_moving = true
		dir += camera.basis[0]
	if Input.is_action_pressed('move_up') and is_grounded:
		velocity.y = JUMP_SPEED
		is_grounded = false
	
	var speed = WALK_SPEED
	if Input.is_action_pressed("move_fast"):
		speed = RUN_SPEED
		is_fast = true
			
		
	dir.y = 0
	dir = dir.normalized()
	
	velocity.y += delta * gravity
	
	
	
	var hv = velocity
	hv.y = 0
	
	var new_pos = dir * speed
	var accel = DE_ACCELERATION
	if (dir.dot(hv) > 0):
		accel = ACCELERATION
	hv = hv.linear_interpolate(new_pos, accel * delta)
	velocity.x = hv.x
	velocity.z = hv.z
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	if is_moving and is_grounded:
		var angle = atan2(hv.x, hv.z)
		var char_rot = character.get_rotation()
		char_rot.y = angle
		character.set_rotation(char_rot)
		#if anim_player.current_animation != "Run":
		#	print('play run animation')
		if is_fast:
			anim_player.current_animation = "Walk"
			anim_player.set_speed_scale(7)
			#print('running')
		else:
			anim_player.current_animation = "Walk"
			anim_player.set_speed_scale(4)
			#print('walking')
	elif not is_grounded:
		anim_player.current_animation = "Idle"
		#anim_player.set_speed_scale(2)
		#print('falling')
	else:
		anim_player.current_animation = "Idle"
		#anim_player.set_speed_scale(2)
		#print('idle')
		
	#print('current: ', anim_player.current_animation)
	#print('prog: ', anim_player.current_animation_position, '/', anim_player.current_animation_length)
	
	
func equip(obj):
	print('equipping ', obj.name, ' at ', obj.slot)
	print(obj.get_children())
	var kit = equip[obj.slot]['kit']
	for c in kit.get_children():
		print('removing equip mesh: ', c.get_parent().name, '>', c.name)
		c.queue_free()
	obj.scale = Vector3(15, 15, 15)
	obj.set('translation', Vector3(+1, 0,0))
	kit.add_child(obj)
	equip[obj.slot]['item'] = obj

func unequip(slot):
	pass
	
	
func attack():
	#var hit = false
	if not target or not is_instance_valid(target):
		ui.notify('Kein Ziel zum Angreifen!')
		return false
	if not equip["mainhand"].get('item', false):
		ui.notify('Keine Waffe ausgerüstet!')
		return false
	var weapon = equip["mainhand"]["item"]
	if randf() < weapon.hit:
		var d = weapon.noise
		var dmg = int(rand_range(weapon.damage-d, weapon.damage+d))
		ui.notify(String(dmg) + ' Schaden')
		target._get_hit(dmg)
		ui.update_target(target)
	else:
		ui.notify('Verfehlt.')
	return true


func block():
	blocking = true
	block_timer.start(1)



func _on_block_timer_timeout():
	blocking = false
	print('fertig mit blocken')
	


func has_flag(key):
	for f in flags:
		if f == key:
			return true
	return false


func set_flag(key):
	flags.append(key)


func rem_flag(key):
	while key in flags:
		flags.remove(key)