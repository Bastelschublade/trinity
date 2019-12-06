extends KinematicBody
class_name Player


var velocity = Vector3()
var gravity = -4.6
var camera
var character
var raycast
var target
var blocking = false
var block_timer
var flags = []
var buffs = []

export(float) var RUN_SPEED = 13
var WALK_SPEED = 1.5
var JUMP_SPEED = 2
var ACCELERATION = 1.5
var DE_ACCELERATION = 5

# equip is array of Items
var slots = ["mainhand", "offhand", "chest", "legs", "boots"]
var gear = {}
var bones = {"mainhand": 'RightHand'}
var attacking = false
var dead = false
var reg_time = 0

onready var ui = get_node('/root/World/Ui')
onready var inventory = get_node('/root/World/Ui/GameMenu/TabContainer/Inventar/Inventory')
onready var arma = get_node('Root')
onready var stats = get_node('Stats')
onready var anim_player = get_node('AnimationPlayer')



# Called when the node enters the scene tree for the first time.
func _ready():
	#print('Character ready!')
	character = get_node('.')
	raycast = get_node('RayCast')
	#print(anim_player)
	block_timer = Timer.new()
	block_timer.connect("timeout", self, '_on_block_timer_timeout')
	get_node('.').add_child(block_timer)
	
	# setup equipment dict
	for s in slots:
		gear[s] = {}
		if bones.get(s, false):
			var kit = BoneAttachment.new()
			kit.set_name(s)
			arma.add_child(kit)
			kit.set_bone_name(bones[s])
			gear[s] = {'kit':kit}
	print('anim childs:')
	print(anim_player.get_animation_list())


func _physics_process(delta):
	# 1s reg stuff
	reg_time += delta
	if reg_time > 1:
		reg_time -= 1  # don't waste the milliseconds between frames
		#self.stats.current.health += self.stats.current.hreg
		#self.stats.current.power += self.stats.current.preg
		#ui.update_player_frame()
		
		
	if attacking or dead:
		return
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
			anim_player.current_animation = "run"
			#anim_player.set_speed_scale(7)
			#print('running')
		else:
			anim_player.current_animation = "walk"
			#anim_player.set_speed_scale(4)
			#print('walking')
	elif not is_grounded:
		anim_player.current_animation = "jump"
		#anim_player.set_speed_scale(2)
		#print('falling')
	else:
		anim_player.current_animation = "idle"
		#anim_player.set_speed_scale(2)
		#print('idle')
		
	#print('current: ', anim_player.current_animation)
	#print('prog: ', anim_player.current_animation_position, '/', anim_player.current_animation_length)
	
	
func equip_item(obj):
	print('equipping ', obj.name, ' at ', obj.slot)
	print(obj.get_children())
	var kit = gear[obj.slot]['kit']
	for c in kit.get_children():
		print('removing equip mesh: ', c.get_parent().name, '>', c.name)
		c.queue_free()
	obj.scale = Vector3(2, 2, 2)
	#obj.set('translation', Vector3(+1, 0,0))
	#obj.rotate()
	# remove collision shape
	var collider = obj.get_node('Body/CollisionShape')
	collider.queue_free()
	kit.add_child(obj)
	gear[obj.slot]['item'] = obj
	stats.update()


func unequip(slot):
	print('unequip slot ', slot)


func finish_attack():
	
	# check hit
	if randf() > stats.current.hit:
		ui.notify('Verfehlt.')
		return false
	# calc dmg
	var dmg
	if not gear["mainhand"].get('item', false):
		print('no weapon')
		dmg = 2
	else:
		print('weapon')
		var weapon = gear["mainhand"]["item"]
		var d = weapon.noise
		dmg = int(rand_range(weapon.damage-d, weapon.damage+d))
	ui.notify(String(dmg) + ' Schaden')
	target.get_hit(dmg)
	ui.update_target(target)
	return true


func attack():
	
	# check target valid
	if not target or not is_instance_valid(target):
		ui.notify('Kein Ziel zum Angreifen!')
		return false
	
	# check target alive
	if not target.alive:
		ui.notify('Ziel ist schon erledigt.')
	
	# check weapon equiped
	if not gear["mainhand"].get('item', false):
		attacking = true
		if randf() < 0.8:
			anim_player.play('punch')
		else:
			anim_player.play('kick')
		return true
		
	# default attack
	attacking = true
	anim_player.play('attack')
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


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name in ['attack', 'punch', 'kick']:
		self.finish_attack()
		print('att finished')
		attacking = false


func add_health(hp):
	self.stats.current.health += hp
	if stats.current.health > stats.base.health:
		print('already on max health..')
		stats.current.health = stats.base.health
	elif stats.current.health < 0:
		stats.current.health = 0
		die()
	ui.update_player_frame()


func add_power(pp):
	self.stats.current.power += pp
	if stats.current.power > stats.base.power:
		stats.current.power = stats.base.power
	elif stats.current.power < 0:
		stats.current.power = 0
	ui.update_player_frame()


func get_hit(dmg):
	# TODO: blocking and stuff
	print('got hit: ', dmg)
	add_health(-dmg)


func die():
	if !dead:
		anim_player.play('death')
		self.dead = true