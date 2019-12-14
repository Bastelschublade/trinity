extends GameObject

export(float) var respawn_time = 10
export(String) var collect_item = 'hay'

onready var timer = Timer.new()
onready var body = get_node('Body')


func _ready():
	timer.set_wait_time(respawn_time)
	timer.set_one_shot(true)
	#timer.set_auto_start(false)
	timer.connect("timeout", self, "_on_timer_timeout")
	self.add_child(timer)


func interact():
	print('hay clicked')
	self.timer.start()
	self.remove_child(body)
	Global.player.inventory.add_item('hay')


func _on_timer_timeout():
	print('respawn')
	self.add_child(body)