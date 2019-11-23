extends Path

onready var follow = get_node('Follow')
var speed = 5
var moving = false


func _ready():
	var events = get_node("/root/Events")
	events.connect('start_journey', self, "_on_start_journey")


func _process(delta):
	if moving:
		follow.set_offset(follow.get_offset() + delta*speed)
	if 1-follow.get_unit_offset() < 0.01:
		moving = false
		# todo dismount or stop signale


func _on_start_journey(data):
	print('reise gestartet')
	print(data)
	self.moving=true