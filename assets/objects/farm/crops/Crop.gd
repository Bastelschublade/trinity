extends Spatial
class_name Crop

export(int)    var  crop_item    = 0
export(int)    var  grow_time    = 60  # seconds
export(int)    var  crop_harvest = 2
export(String) var  crop_name    = 'Pflanze'

var ripe = false
var timer

onready var finish = get_node('Finish')
onready var growing = get_node('Growing')


func _ready():
	# todo create and connect timer with script using grow_time
	finish.set_visible(false)
	growing.set_visible(true)
	timer = Timer.new()
	timer.set_autostart(true)
	timer.set_wait_time(self.grow_time)
	timer.set_one_shot(true)
	timer.connect("timeout", self, "_on_timer_timeout") 
	self.add_child(timer)


func _on_timer_timeout():
	ripe = true
	growing.set_visible(false)
	finish.set_visible(true)


func get_progress():
	return 0