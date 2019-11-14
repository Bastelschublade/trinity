extends Spatial
class_name Creature


export(float) var max_health = 1
export(float) var max_power = 0
export(String) var creature_type = 'Kreatur'
export(bool) var alive = true
export(float) var respawn_time = 20

onready var current_health = max_health
onready var current_power = max_power


func _ready():
	# specify prev defaults
	name = 'Kreatur'


func _rel_health():
	return current_health / max_health * 100


func _add_health(amount):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	if current_health <= 0:
		current_health = 0
		self._die()


func _get_hit(amount):
	self._add_health(-amount)


func _die():
	print('Dieing: ', self)
	self.queue_free()