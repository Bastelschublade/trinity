extends Spatial


var TALK_RANGE = 3
var camera
onready var player = Global.get_player()
export(Vector3) var player_pos

 

func _ready():
	Global.ui = get_node("Ui")
	#player_pos = player.get_global_transform().origin
	camera = self.player.get_node("target/Camera")
	#player_pos = player.get_translation()
	#player_pos.y += 5
	var spawn_pos = Vector3(0,0,0)
	var spawn = get_node('Spawn')
	if spawn:
		spawn_pos = spawn.get_translation()
		print('found spawn at: ', spawn_pos)
	player.set('translation', spawn_pos)
	self.add_child(player)
	Global.ui.get_node('Cursor').camera = get_viewport().get_camera()


func _physics_process(delta):
	player_pos = player.get_global_transform().origin