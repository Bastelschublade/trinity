extends Node

export(Array, Material) var materials
export(Array, PackedScene) var models
export(Array, Texture) var textures


var mesh_picker_res = preload('res://assets/scenes/game/npc_generator/skin_editor/mesh_picker.tscn')
var skin_picker_res = preload('res://assets/scenes/game/npc_generator/skin_editor/skin_picker.tscn')

onready var skinlayers = get_node('Viewport')
onready var meshes = get_node('Layout/Sidebar/Settings/Mesh')
onready var skins = get_node('Layout/Sidebar/Settings/Skin')
onready var head_attachments = get_node('Preview/CharacterDummy/Player/Root/HeadAttachment/Skin')

var data = {}

func _ready():
	self._new_mesh_picker()
	self._new_skin_picker()
	self._new_skin_picker()



func _new_mesh_picker():
	var picker = mesh_picker_res.instance()
	var mesh_p = picker.get_node('Mesh')
	var mat_p = picker.get_node('cols/Material')
	for i in range(len(models)):
		var m = models[i]
		var fname = m.get_path().split('/')[-1]
		mesh_p.add_item(fname, i)
	for i in range(len(materials)):
		var m = materials[i]
		var fname = m.get_path().split('/')[-1].split('.material')[0]
		mat_p.add_item(fname, i)
	meshes.add_child(picker)
	

func _new_skin_picker():
	var picker = skin_picker_res.instance()
	var picks = picker.get_node('OptionButton')
	for i in range(len(textures)):
		var t = textures[i]
		var fname = t.get_path().split('/')[-1]
		picks.add_item(fname, i)
	skins.add_child(picker)


func _update():
	print('update preview')
	for c in skinlayers.get_children():
		c.queue_free()
		print('removing: ', c.name)
	for s in get_node('Layout/Sidebar/Settings/Skin').get_children():
		var btn = s.get_node('OptionButton')
		var new_layer = TextureRect.new()
		print(btn.get_selected_id())
		print(textures[btn.get_selected_id()])
		new_layer.set_texture(textures[btn.get_selected_id()])
		skinlayers.add_child(new_layer)
	print('update 3d')
	for c in head_attachments.get_children():
		c.free()
	for s in meshes.get_children():
		var btn = s.get_node('Mesh')
		var idx = btn.get_selected_id()
		print('selected model: ', idx)
		print(models[idx].get_path())
		var new_model = models[idx].instance()
		#print('neues model: ', new_model.pos)
		head_attachments.add_child(new_model)
	
	#var test_beard_res = preload('res://assets/creatures/character/accessories/head/beard.tscn')
	#var test_beard = test_beard_res.instance()
	#self.head_attachments.add_child(test_beard)


func _rotate(dir):
	var character = get_node('Preview/CharacterDummy')
		# rotates around own y not global y?
	var angle = 0.4
	var rot = character.get_rotation()
	rot.y += dir*angle
	character.set_rotation(rot)


func _export_pressed():
	data['skins'] = []
	for s in skins.get_children():
		var texture_path = textures[s.get_node('OptionButton').get_selected_id()].get('resource_path')
		data['skins'].append({'res': texture_path})
	data['scenes'] = []
	for m in meshes.get_children():
		var m_data = {}
		var scene_path = models[m.get_node('Mesh').get_selected_id()].get('resource_path')
		m_data['res'] = scene_path
		data['scenes'].append(m_data)
	$FileDialog.popup()


func _export_confirmed():
	var fpath = $FileDialog.current_path
	if not fpath.ends_with('.json'):
		fpath += '.json'
	var file = File.new()
	file.open(fpath, File.WRITE)
	file.store_string(to_json(data))
	file.close()
	#$SaveWindow.hide()


func _main_menu_pressed():
	Global.goto_scene('res://assets/scenes/mainmenu/MainMenu.tscn')
