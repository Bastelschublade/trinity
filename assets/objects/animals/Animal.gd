extends KinematicBody
class_name Animal

export(float) var animal_respawn = 5
export(float) var animal_walk_speed = 0.2
export(float) var animal_run_speed = 4
export(String) var animal_name = "Nutztier"

#var direction = Vector3(0,0,0)
var dead = false
var turn_angle
var target
var speed = 0
var task = 'browse'
var walking = false
var velocity = Vector3(0,0,0)
onready var anim_player = get_node('AnimationPlayer')

func _ready():
	var looped_anims = ['Idle', 'Walk', 'WalkSlow']
	for anim_name in anim_player.get_animation_list():
		if anim_name in looped_anims:
			anim_player.get_animation(anim_name).loop = true
	anim_player.current_animation = 'Idle'
	print(anim_player.is_playing())
	var motion_timer = Timer.new()
	motion_timer.connect("timeout", self, "_on_motion_timer_timeout")
	motion_timer.start(4)
	self.add_child(motion_timer)

# find direction to obj
#var dir = (target_obj.get_transform().origin - get_transform().origin).normalized()
# look to obj (player)
# look_at(target_obj.get_transform().origin, Vector3(0,1,0))

func _physics_process(delta):
	var dir = self.get_global_transform().basis[2]  # local basis the pig is facing
	dir.y = 0
	var velocity = dir.normalized() * self.speed
	move_and_slide(velocity, Vector3(0,1,0))


func on_click():
	print('animal clicked')
	print('speed: ', speed)
	print('name: ', animal_name)
	print('anim: ', anim_player.current_animation, anim_player.is_playing())
	
	var menu_scene = preload('res://assets/ui/CursorMenu.tscn')
	var c_menu = menu_scene.instance()
	c_menu.set_position(get_viewport().get_mouse_position())
	#var button
	get_node('/root/Level/Ui/CursorMenu').add_child(c_menu)
	
	
func _on_motion_timer_timeout():
	print('local translation', self.get_translation())
	print('randomize motion')
	if task == 'browse':
		var new_speed = randi()%2 * animal_walk_speed
		if new_speed == speed: # either motion or angle change
			turn_angle = rand_range(-0.5, 0.5)
			var rot = self.get_rotation()
			print(rot)
			rot.y = rot.y + turn_angle
			self.set_rotation(rot)
		else:
			speed = new_speed
		if speed == 0:
			anim_player.current_animation = "Idle"
		else:
			anim_player.current_animation = "WalkSlow"