extends Spatial


var TALK_RANGE = 3
var camera
var player
export(Vector3) var player_pos
export(Dictionary) var item_db

 

func _ready():
	player = get_node("Character")
	player_pos = player.get_global_transform().origin
	camera = get_node("Character/target/Camera")
	#load item db
	var item_db_res = "res://assets/itemdb.json"
	var file = File.new()
	assert file.file_exists(item_db_res)
	file.open(item_db_res, file.READ)
	item_db = parse_json(file.get_as_text())


func _physics_process(delta):
	player_pos = player.get_global_transform().origin

		
		
	
