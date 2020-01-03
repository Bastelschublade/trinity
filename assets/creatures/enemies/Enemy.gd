extends Creature
class_name Enemy

export(bool) var enemy_is_boss = false
export(bool) var enemy_is_aggressive = true
export(float) var enemy_trigger_distance = 10  
# not used use collision shape in detection area with signal

enum States {IDLE, CHASE, BROWSE, EVADE}


var target = null
var attacking = false
var running = false
var state = States.IDLE  # idle, chase, 
var attack_range = 2
var attack_timer = Timer.new()


func _ready():
	._ready()
	print('enemy attack speed: ', creature_name, stats.current.speed)
	attack_timer.set_wait_time(1/self.stats.current.speed)
	attack_timer.set_one_shot(true)
	self.add_child(attack_timer)
	dt = 0


func _process(delta):
	dt += delta
	if not alive:
		return
	if state == States.IDLE:
		if not anim_player.current_animation == 'idle':
			anim_player.play('idle')
	elif state == States.CHASE:
		var pos = self.body.get_global_transform().origin
		var tar_pos = target.get_global_transform().origin
		#var direction =
		self.body.look_at(tar_pos, Vector3(0,1,0))
		if dt > 1:
			print('spid: ', pos, ' player: ', tar_pos)
		if pos.distance_to(tar_pos) > attack_range and not attacking:
			anim_player.play('walk')
			if dt > 1:
				print('running')
			#run_to(tar_pos)
			var velocity = tar_pos - pos
			velocity = velocity.normalized() * creature_run_speed
			self.body.move_and_slide(velocity, Vector3(0,1,0))
			# replace later by waypoints instead of straight line?
			# And or use mesh instance?
		else:
			if dt> 1:
				print('attacking')
			if attack_timer.is_stopped():
				start_attack()
			#else:
			#	print('attack on cd: ', attack_timer.get_time_left())
		if dt>1:
			dt = 0

func move_forward():
	#print('running to: ', pos)
	#velocity = 
	self.body.move_and_slide(Vector3(0,0,1))


func start_attack():
	self.anim_player.play('attack')
	self.attacking = true
	self.attack_timer.start()


func finish_attack():
	#print(self.stats.current)
	var dmg = self.stats.current.damage
	target.get_hit(dmg)
	attacking = false


func _on_animation_finished(anim_name):
	if anim_name == 'death':
		self.death()
	if anim_name == 'attack':
		self.finish_attack()


func _on_Detection_body_entered(body):
	if body is Player:
		target = body
		state = States.CHASE


func _on_Detection_body_exited(body):
	state = States.IDLE
