extends Node

export(NodePath) var player_node
export(NodePath) var settings_node
export(Array, Material) var hair_colors
export(Array, PackedScene) var hair_models
export(Array, PackedScene) var beard_models
export(Array, PackedScene) var accessory_models
export(Array, Texture) var skin_textures
export(Array, Texture) var face_textures
# TODO replace skin with dynamic shader and add face_texture, base_texture  and so on

#		'black': preload('res://assets/materials/BlackCharacter.material'),
#		'brown': preload('res://assets/materials/BrownCharacter2.material'), 
#		'blonde': preload('res://assets/materials/BlondeCharacter.material'),
#		'red': preload('res://assets/materials/OrangeCharacter3.material')
#	]

var hair_colors_i = 0
var hair_models_i = 0
var beard_models_i = 0
var skin_textures_i = 0
var accessory_models_i = 0
var face_textures_i = 0


onready var player = get_node(player_node)
onready var hair_slot = player.get_node('Root/HeadAttachment/Hair')
onready var beard_slot = player.get_node('Root/HeadAttachment/Beard')
onready var accessory_slot = player.get_node('Root/HeadAttachment/Accessory')
onready var player_mesh = player.get_node('Root/characterMedium')#.get('surface_1/material')
onready var shader = player_mesh.get('mesh').get('surface_1/material')


func _ready():
	print('Player:', player.get_name())
	update_hair()


func update_hair():
	var model_res = hair_models[hair_models_i]
	var color = hair_colors[hair_colors_i]
	var beard_model_res = beard_models[beard_models_i]
	
	# update hair color in shader
	

	var col = Color(color.get('albedo_color'))
	print(col)
	print(shader.get('hair_color'))
	shader.set('shader_param/hair_color', col)
	
	# remove old hair and beard
	for c in hair_slot.get_children():
		c.queue_free()
	for c in beard_slot.get_children():
		c.queue_free()
	
	# instance new hair/beard and assign material
	if model_res:
		var hair = model_res.instance()
		var mesh = hair.get_child(0)  # NOTE fix this later
		mesh.set('material/0', color)
		hair_slot.add_child(hair)
	if beard_model_res:
		var beard = beard_model_res.instance()
		var bmesh = beard.get_child(0)
		bmesh.set('material/0', color)
		beard_slot.add_child(beard)


func update_accessory():
	var model_res = accessory_models[accessory_models_i]
	for c in accessory_slot.get_children():
		c.queue_free()
	if model_res:
		var acc = model_res.instance()
		accessory_slot.add_child(acc)


func reset_index(i, vec):
	if i > len(vec)-1:
		i = 0
	elif i < -len(vec):
		i = len(vec)-1
	return i


func _change_hair_color(di):
	hair_colors_i = reset_index(hair_colors_i+di, hair_colors)
	#print(hair_colors_i)
	update_hair()


func _change_hair_model(di):
	hair_models_i = reset_index(hair_models_i+di, hair_models)
	update_hair()


func _change_beard(di):
	beard_models_i = reset_index(beard_models_i+di, beard_models)
	update_hair()


func _change_accessory(di):
	accessory_models_i = reset_index(accessory_models_i+di, accessory_models)
	update_accessory()


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
	shader.set('shader_param/texture_face', text)
