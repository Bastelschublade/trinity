extends Node

export(NodePath) var player_node
export(NodePath) var settings_node
export(Array, Material) var hair_colors
export(Array, PackedScene) var hair_models
export(Array, PackedScene) var beard_models
export(Array, PackedScene) var accessory_models
export(Array, Texture) var base_textures
export(Array, Texture) var skin_textures
export(Array, Texture) var face_textures
# TODO replace skin with dynamic shader and add face_texture, base_texture  and so on

var hair_skins = {
		'blonde1': preload('res://assets/creatures/character/hair/hair_blonde_1.png'),
		'blonde2': preload('res://assets/creatures/character/hair/hair_blonde_2.png'),
		'black1': preload('res://assets/creatures/character/hair/hair_black_1.png'),
		'black2': preload('res://assets/creatures/character/hair/hair_black_2.png'),
		'red1': preload('res://assets/creatures/character/hair/hair_red_1.png'),
		'red2': preload('res://assets/creatures/character/hair/hair_red_2.png'),
		'brown1': preload('res://assets/creatures/character/hair/hair_brown_1.png'),
		'brown2': preload('res://assets/creatures/character/hair/hair_brown_2.png'),
		'null': null,
	}

var hair_colors_i = 0
var hair_models_i = 0
var beard_models_i = 0
var skin_textures_i = 0
var accessory_models_i = 0
var face_textures_i = 0
var base_textures_i = 0

var player_res = preload('res://assets/creatures/player/Player.tscn')

onready var player = get_node(player_node)
onready var head_slot = player.get_node('Root/HeadAttachment/Skin')
onready var skin = player.get_node('Skin')
#onready var player_mesh = player.get_node('Root/characterMedium')#.get('surface_1/material')



func _ready():
	#print('Player:', player.get_name())
	pass


func reset_index(i, vec):
	if i > len(vec)-1:
		i = 0
	elif i < -len(vec):
		i = len(vec)-1
	return i


func _update():
	var model_res = hair_models[hair_models_i]
	var color = hair_colors[hair_colors_i]
	print(color.get('resource_name').to_lower())
	var beard_model_res = beard_models[beard_models_i]
	var access_model_res = accessory_models[accessory_models_i]

	
	var hair_skin = 1
	var hair_color_name = color.get('resource_name')
	#var col = Color(color.get('albedo_color'))
	#shader.set('shader_param/hair_color', col)

	# remove old attachments
	for c in head_slot.get_children():
		c.queue_free()

	# instance new hair/beard and assign material
	if model_res:
		var hair = model_res.instance()
		hair_skin = hair.hair_skin
		var mesh = hair.get_child(0)  # NOTE fix this later
		for s in hair.change_materials.split(','):
			mesh.set('material/'+s, color)
		head_slot.add_child(hair)
	if beard_model_res:
		var beard = beard_model_res.instance()
		var bmesh = beard.get_child(0)
		bmesh.set('material/0', color)
		head_slot.add_child(beard)
	if access_model_res:
		var acc = access_model_res.instance()
		head_slot.add_child(acc)
	var hair_name = hair_color_name.to_lower()+String(hair_skin)
	var hair_texture = null
	if hair_skin == 0:
		hair_name = 'null'
	if hair_name in hair_skins:
		hair_texture = hair_skins[hair_name]
	player.get_node('Skin/Hair').set('texture', hair_skins[hair_name])



func _change_hair_color(di):
	hair_colors_i = reset_index(hair_colors_i+di, hair_colors)
	#print(hair_colors_i)
	_update()


func _change_hair_model(di):
	hair_models_i = reset_index(hair_models_i+di, hair_models)
	_update()


func _change_beard(di):
	beard_models_i = reset_index(beard_models_i+di, beard_models)
	_update()


func _change_accessory(di):
	accessory_models_i = reset_index(accessory_models_i+di, accessory_models)
	_update()


func _on_Rotate_pressed(da):
	# rotates around own y not global y?
	var angle = 0.4
	var rot = player.get_rotation()
	rot.y += da*angle
	player.set_rotation(rot)


func _change_face(df):
	face_textures_i = reset_index(face_textures_i+df, face_textures)
	print(face_textures[face_textures_i])
	var text = face_textures[face_textures_i]
	skin.get_node('Face').set('texture', text)
	#shader.set('shader_param/texture_face', text)


func _change_base(db):
	base_textures_i = reset_index(base_textures_i+db, base_textures)
	var base = base_textures[base_textures_i]
	skin.get_node('Base').set('texture', base)
	#shader.set('shader_param/texture_base', base)


func _on_Start_pressed():
	var data = self._init_game_save()
	#Global.player = self.player.duplicate()
	#print(Global.player.get_node('Root/characterMedium').get('material/0'))
	Global.player = player_res.instance()
	Global.player.load_from_data(data)
	print(Global.player)
	Global.player.freeze = false
	Global.player.get_node('target/Camera').set_current(true)
	Global.player.get_node('target/Camera').manually_init()
	Global.goto_scene("res://World.tscn")


func _init_game_save():
	var data = {'player':{'skin':{'textures':{}, 'objects':{}}}}
	
	# save skin layers
	var texs = {}
	texs['base'] = base_textures[base_textures_i].get('resource_path')
	texs['face'] = face_textures[face_textures_i].get('resource_path')
	#texs['hair'] = hair_textures[hair_textures_i].get('resource_path')
	texs['hair'] = null
	data['player']['skin']['textures'] = texs
	
	# save 3d objects
	var mods = {}
	if hair_models[hair_models_i]:
		mods['hair'] = {'res': hair_models[hair_models_i].get('resource_path'), 
				'mat': hair_colors[hair_colors_i].get('resource_path')}
	data['player']['skin']['objects'] = mods
	
	data['player']['name'] = get_node('Customizer/Dialog/Panel/MarginContainer/VBoxContainer/ScrollContainer/Settings/Name/Input').text
	
	# write to gamesave
	var game_save = File.new()
	game_save.open('user://game_save.json', File.WRITE)
	game_save.store_string(to_json(data))
	game_save.close()
	print('saved')
	return data