extends Creature
class_name NPC

# variables set from user
export(float) var npc_talk_range = 10
export(String) var npc_next_view = "start"
# auto load from resource
export(String, FILE, '*.png') var npc_skin_file
export(String, FILE, '*.json') var npc_dialog_file


# variables maintained by script
var dialog
var reputation = 0



func start_dialog():
	var dialog_scene = preload("res://assets/ui/dialog/Dialog.tscn")
	var dialog = dialog_scene.instance()
	# assign the json dialog to the dialog obj
	#print(object.npc_dialog)
	dialog.views = self.dialog
	dialog.start_pos = self.get_global_transform().origin
	dialog.quit_distance = 5
	dialog.npc = self
	get_node('/root/World/Ui/Dialog').add_child(dialog)


func load_dialog():
	#print('loading file')
	var file = File.new()
	assert file.file_exists(npc_dialog_file)
	file.open(npc_dialog_file, file.READ)
	var dia = parse_json(file.get_as_text())
	var vali = validate_json(file.get_as_text())
	print(vali)
	return dia


func interact():
	var object_pos = self.get_global_transform().origin
	var distance = object_pos.distance_to(get_node('/root/World').player_pos)  # player_pos is exported
	if distance > npc_talk_range:
		ui.notify('Zu weit entfernt um sich zu unterhalten.')
		return
	start_dialog()


func trigger(data):
	pass


func _ready():
	if npc_dialog_file:
		dialog = load_dialog()
	#print(npc_name, ' spawned')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'death':
		ui.notify(creature_name + ' getötet.')
