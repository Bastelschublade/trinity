extends Spatial


var TALK_RANGE = 3
var camera
var player
export(Vector3) var player_pos

 

func _ready():
	player = get_node("Character")
	player_pos = player.get_global_transform().origin
	camera = get_node("Character/target/Camera")


func _physics_process(delta):
	player_pos = player.get_global_transform().origin