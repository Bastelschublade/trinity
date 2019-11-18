extends Spatial
class_name Creature


export(float) var max_health = 1
export(float) var max_power = 0
export(String) var creature_type = 'Kreatur'
export(bool) var alive = true
export(float) var respawn_time = 120
export(float) var despawn_time = 20
export(int) var level = 1
export(String, 'default', 'loot', 'attack', 'talk', 'inspect', 'menu') var interaction = 'default'
export(float) var walk_speed = 0.2
export(float) var run_speed = 0.6
export(String) var creature_name = 'Kreatur'


# automatic assigned variables
var velocity = Vector3(0,0,0)
var speed = 0
var buffs = []
onready var ui = get_node('/root/Level/Ui')
onready var current_health = max_health
onready var current_power = max_power
onready var body = get_node('Body')
onready var spawn_position = get_global_transform().origin
onready var anim_player = get_node('Body/AnimationPlayer')


func _ready():
	# specify prev defaults
	pass


func _rel_health():
	return current_health / max_health * 100


func _add_health(amount):
	current_health += amount
	print('current health: ', current_health)
	if current_health > max_health:
		current_health = max_health
	if current_health <= 0:
		current_health = 0
		self._die()


func _get_hit(amount):
	print('got hit')
	self._add_health(-amount)


func _die():
	print('Dieing: ', self)
	self.queue_free()


func interact():
	print('dummy creature interaction: ', self.interaction)


func select():
	ui.update_target(self)