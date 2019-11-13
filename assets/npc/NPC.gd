extends KinematicBody
class_name NPC

# variables set from user
export(String) var npc_name
export(String) var npc_desc
export(float) var npc_max_health
export(String) var npc_gang
export(float) var npc_reputation
export(bool) var npc_can_talk
export(String) var npc_next_view = "start"
# auto load from resource
export(String, FILE, '*.png') var npc_skin_file
export(String, FILE, '*.json') var npc_dialog_file

# variables maintained by script
var dialog
var health


func start_dialog():
	var dialog_scene = preload("res://assets/ui/dialog/Dialog.tscn")
	var dialog = dialog_scene.instance()
	# assign the json dialog to the dialog obj
	#print(object.npc_dialog)
	dialog.views = self.dialog
	dialog.start_pos = self.get_global_transform().origin
	dialog.quit_distance = 5
	dialog.npc = self
	get_node('/root/Level/Ui/Dialog').add_child(dialog)
	

func load_dialog():
	#print('loading file')
	var file = File.new()
	assert file.file_exists(npc_dialog_file)
	file.open(npc_dialog_file, file.READ)
	var dia = parse_json(file.get_as_text())
	var vali = validate_json(file.get_as_text())
	print(vali)
	return dia
	


func _ready():
	health = npc_max_health
	if npc_dialog_file:
		dialog = load_dialog()
	#print(npc_name, ' spawned')
