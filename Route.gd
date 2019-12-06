extends Path



var speed = 5
var moving = false

onready var follow = get_node('Follow')
onready var player = get_node('/root/World/Character')
onready var seat = get_node('Follow/CraftRaft/PlayerPosition')


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
	var seat_pos = seat.get_global_transform().origin
	var transform = player.get_global_transform()
	transform.origin = seat_pos
	player.set_global_transform(transform)