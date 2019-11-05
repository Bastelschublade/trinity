extends Node2D

# preload cursors to switch without lag
onready var default    = preload('res://assets/ui/cursor/sprites/cursorGauntlet_blue.png')
onready var collect    = preload('res://assets/ui/cursor/sprites/cursorGauntlet_bronze.png')
onready var talk       = preload('res://assets/ui/cursor/sprites/cursorGauntlet_bronze.png')
onready var attack     = preload('res://assets/ui/cursor/sprites/cursorSword_bronze.png')
onready var sprite     = get_node('Sprite')
onready var tooltip    = get_node('Sprite/Tooltip')
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


func collect_object(object):
	var inventory = get_parent().get_node('GameMenu/TabContainer/Inventar/Inventory')
	var loot_table = object.get_node('LootTable').loot
	for item_id in loot_table:
		#var item = get_node('/root/Level/Data/ItemDB').get_child(item_id).duplicate()
		inventory.add_item(item_id)
	object.queue_free()





func update_cursor(object):
	self.sprite.texture = default
	if object is NPC:
		self.sprite.texture = attack
		self.tooltip.set_text(object.npc_name + '\n' + object.npc_desc)
		self.tooltip.set('visible', true)
	elif object is GameObject:
		self.sprite.texture = collect
		self.tooltip.set_text(object.go_tooltip)
		self.tooltip.set('visible', true)
	elif object is Animal:
		self.sprite.texture = attack
		self.tooltip.set_text(object.animal_name)
		self.tooltip.set('visible', true)


func process_click(object, distance):
	if object is GameObject:
		collect_object(object)
	elif object is NPC and distance < TALK_RANGE:
		object.start_dialog()
	elif object is Animal and distance < TALK_RANGE:
		object.on_click()


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
	var object_pos = object.get_global_transform().origin
	var distance = object_pos.distance_to(get_node('/root/Level').player_pos)  # player_pos is exported
	update_cursor(object)
	if Input.is_action_just_pressed('grab'):
		process_click(object, distance)
	

