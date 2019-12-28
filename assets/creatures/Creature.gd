extends Spatial
class_name Creature


export(String) var creature_type = 'Kreatur'
export(float) var creature_respawn_time = 30
export(float) var creature_despawn_time = 10
export(int) var creature_level = 1
export(String, 'default', 'loot', 'attack', 'talk', 'inspect', 'menu') var interaction = 'default'
export(float) var creature_walk_speed = 0.2
export(float) var creature_run_speed = 0.6
export(String) var creature_name = 'Kreatur'


# automatic assigned variables
onready var ui = get_node('/root/World/Ui')
onready var body = get_node('Body')
onready var spawn_position = get_global_transform().origin
onready var anim_player = get_node('Body/AnimationPlayer')
#onready var stats = get_node('Stats')
#onready var loot_table = get_node('LootTable')

var stats
var velocity = Vector3(0,0,0)
var speed = 0
var buffs = []
var alive = true
var spawn = Vector3(0,0,0)
var despawn_timer = Timer.new()
var respawn_timer = Timer.new()

var dt = 0

func _ready():
	despawn_timer.set_one_shot(true)
	respawn_timer.set_one_shot(true)
	despawn_timer.connect("timeout", self, "_on_despawn_timeout")
	respawn_timer.connect("timeout", self, "_on_respawn_timeout")
	self.add_child(despawn_timer)
	self.add_child(respawn_timer)
	if anim_player:
		# expect to have at least idle and death animation
		anim_player.connect("animation_finished", self, "_on_animation_finished")
		anim_player.play('idle')
	stats = get_node('Stats')
	#if self.creature_name == 'Spinne':
		#print('SPINNE: \n')
		#print(stats.base)
	if not self.stats:
		#print('no stats found adding defaults: ', self.creature_name)
		self.stats = Stats.new()
		self.add_child(self.stats)
		self.stats.base.health = 20
		self.stats.reset_stats()
	#print(stats.base)
	#print(stats.current)


func _process(delta):
	if anim_player:
		pass


func _on_animation_finished(anim_name):
	if anim_name == 'death':
		self.death()


func _on_despawn_timeout():
	print('despawn timer triggerd')
	if respawn_timer.is_stopped():
		return  # make sure it's not already respawned
	self.set_visible(false)
	print('despawned: ', self.creature_name)
	

func _on_respawn_timeout():
	print('respawn timer triggerd')
	print('reswpawn: ', self.creature_name)
	self.anim_player.play('idle')
	self.stats.reset_stats()
	self.set_visible(true)
	self.ui.update_target(get_node('/root/World/Character').target)
	

func rel_health():
	# redundant shortcut for backw. compability
	return stats.rel_health()


func add_health(amount):
	stats.current.health += amount
	if stats.current.health > stats.base.health:
		stats.current.health = stats.base.health
	if stats.current.health <= 0:
		stats.current.health = 0
		self.die()
	# TODO: update target seems not to work this way?
	self.ui.update_target()


func get_hit(amount):
	if not alive:
		ui.notify('Ziel ist bereits tot.')
		return false
	amount -= stats.current.armor
	if amount > 0:
		self.add_health(-amount)
	return true


func die():
	if not self.alive:
		return false
	print('Kreatur stirbt: ', self)
	self.alive = false
	self.despawn_timer.start(self.creature_despawn_time)
	self.respawn_timer.start(self.creature_respawn_time)
	if anim_player:
		self.anim_player.play('death')
	else:
		self.death()


func death():
	print('Kreatur ist tot')
	#if self.loot_table:
	#	print('loot...')


func interact():
	print('dummy creature interaction: ', self.interaction)


func select():
	ui.update_target(self)