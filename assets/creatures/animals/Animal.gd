extends Creature
class_name Animal


# custom properties
export(Dictionary) var eats
#export(bool) var stick_to_spawn = true
#export(float) var animal_browse_radius = 10


# dynamic variables
var turn_angle
var target
var feedable = false
var task = 'browse'
var walking = false
var motion_time = 10
var motion_time_noise = 1
var motion_timer


func _ready():
	# dependent properties
	if eats:
		feedable = true
	
	# redundant default animation settings
	var looped_anims = ['Idle', 'Walk', 'Run']
	for anim_name in anim_player.get_animation_list():
		if anim_name in looped_anims:
			anim_player.get_animation(anim_name).loop = true
	anim_player.current_animation = 'Idle'
	
	# behaviour init
	motion_timer = Timer.new()
	motion_timer.set_wait_time(5)
	motion_timer.connect("timeout", self, "_on_task_timer_timeout")
	self.add_child(motion_timer)
	motion_timer.start()
	#motion_timer.start(motion_time)


func _physics_process(delta):
	var dir = body.get_global_transform().basis[2]  # local basis the animal is facing
	dir.y = 0
	var velocity = dir.normalized() * self.speed
	body.move_and_slide(velocity, Vector3(0,1,0))
	#self.pos
	#print(motion_timer.time_left)


func on_click():
	var menu_scene = preload('res://assets/ui/CursorMenu.tscn')
	var c_menu = menu_scene.instance()
	c_menu.set_position(get_viewport().get_mouse_position())
	#var button
	get_node('/root/Level/Ui/CursorMenu').add_child(c_menu)
	
	
func _on_task_timer_timeout():
	#var t = rand_range(motion_time-motion_time_noise, motion_time+motion_time_noise)
	#print(t)
	#print('local translation', self.get_translation())
	#print('randomize motion')
	if self.creature_name != 'Kuh':
		return
	#print('...')
	if task == 'browse':
		var new_speed = randi()%2 * self.walk_speed
		if new_speed == speed: # either motion or angle change
			#print('same speed change angle')
			turn_angle = rand_range(-0.5, 0.5)
			#print(turn_angle)
			var rot = body.get_rotation()
			#print(rot)
			rot.y = rot.y + turn_angle
			body.set_rotation(rot)
		else:
			speed = new_speed
		if speed == 0:
			anim_player.current_animation = "Idle"
		else:
			anim_player.current_animation = "Walk"
	elif task == 'chase':
		print('chasing player')


func get_hit(dmg):
	# move to creature class
	self.current_health -= dmg
	if self.current_health < 0:
		die()
	# TODO: armor, block dmg type, animation
	

func die():
	# move to creature class
	#add loot and animation
	self.queue_free()