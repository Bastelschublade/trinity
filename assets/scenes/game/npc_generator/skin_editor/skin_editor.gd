extends Node

export(Array, Material) var materials
export(Array, PackedScene) var models
export(Array, Texture) var textures


var mesh_picker_res = preload('res://assets/scenes/game/npc_generator/skin_editor/mesh_picker.tscn')
var skin_picker_res = preload('res://assets/scenes/game/npc_generator/skin_editor/skin_picker.tscn')

onready var skinlayers = get_node('Viewport')
onready var meshes = get_node('Layout/Sidebar/Settings/Mesh')
onready var skins = get_node('Layout/Sidebar/Settings/Skin')


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
		mesh_p.add_item(fname, -1)
	for i in range(len(materials)):
		var m = materials[i]
		var fname = m.get_path().split('/')[-1].split('.material')[0]
		mat_p.add_item(fname, -1)
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
	for s in get_node('Layout/Sidebar/Settings/Skin').get_children():
		var btn = s.get_node('OptionButton')
		var new_layer = TextureRect.new()
		print(btn.get_selected_id())
		print(textures[btn.get_selected_id()])
		new_layer.set_texture(textures[btn.get_selected_id()])
		skinlayers.add_child(new_layer)