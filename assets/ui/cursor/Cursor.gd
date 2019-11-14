extends Node2D

# preload cursors to switch without lag
onready var default    = preload('res://assets/ui/cursor/sprites/cursorGauntlet_blue.png')
onready var collect    = preload('res://assets/ui/cursor/sprites/cursorGauntlet_bronze.png')
onready var talk       = preload('res://assets/ui/cursor/sprites/cursorGauntlet_bronze.png')
onready var attack     = preload('res://assets/ui/cursor/sprites/cursorSword_bronze.png')
onready var sprite     = get_node('Sprite')
onready var tooltip    = get_node('Tooltip')
onready var camera     = get_viewport().get_camera()


var COLLECT_RANGE = 2
var INSPECT_RANGE = 20
var TALK_RANGE    = 5


func get_object_under_mouse():
	var ray_from = camera.project_ray_origin(self.position)
	var ray_to = ray_from + camera.project_ray_normal(self.position) * INSPECT_RANGE
	var space_state = get_node('/root/Level').get_world().direct_space_state
	var selection = space_state.intersect_ray(ray_from, ray_to)
	return selection


func collect_item(item_body):
	var inventory = get_parent().get_node('GameMenu/TabContainer/Inventar/Inventory')
	inventory.add_item(item_body.get_parent().item_id)
	item_body.get_parent().queue_free()



func update_cursor(object):
	self.sprite.texture = default
	if object is NPC:
		self.sprite.texture = talk
		self.tooltip.set_text(object.npc_name + '\n' + object.npc_desc)
		self.tooltip.set('visible', true)
	elif object is Item:
		self.sprite.texture = collect
		var item_id = object.item_id
		var data = get_node("/root/Global").item_db[item_id]
		self.tooltip.set_text(data['name'])
		self.tooltip.set('visible', true)
	elif object is Animal:
		self.sprite.texture = attack
		self.tooltip.set_text(object.animal_name)
		self.tooltip.set('visible', true)



# -------------------------------------- #
# ------ ENGINE HANDLED FUNCTIONS ------ #
# -------------------------------------- #


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _physics_process(delta):
	# update position and object
	self.position = self.get_global_mouse_position()
	var mouse_over = get_object_under_mouse()
	self.tooltip.set('visible', false)
	
	# nothing special return default
	if not 'collider' in mouse_over:
		self.sprite.texture = default
		return
	
	# choose mouse interaction mode
	var object = mouse_over.collider
	var par = object.get_parent()
	update_cursor(par)
	if Input.is_action_just_pressed('select'):
		if par is Creature:
			par.select()
	if Input.is_action_just_pressed('interact'):
		if par is Item or par is Creature:
			par.interact()
	

