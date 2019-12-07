extends Node

# Loads first (AutoLoad) on project start as Node: 'Global' in /root
# acts as wrapper over all scenes to switch between them and store data
# also keeps references to often used objects like world, player or ui

var current_scene
var loading_screen
var loader
var wait_frames
var time_max = 1000 # msec
var item_db
var settings
var ui = null
var player = null
var world = null


func _ready():
	var root = get_tree().get_root()
	# last scene (not these one) should be Level
	current_scene = root.get_child(root.get_child_count()-1)
	var loading_scene = preload('res://assets/ui/LoadingScreen.tscn')
	loading_screen = loading_scene.instance()
	#loading_screen.set_visible(false)
	loading_screen.name = 'LoadingScreen'
	
	#load item db
	var item_db_res = "res://assets/item/itemdb.json"
	var file = File.new()
	assert file.file_exists(item_db_res)
	file.open(item_db_res, file.READ)
	print(validate_json(file.get_as_text()))
	item_db = parse_json(file.get_as_text())
	
	#load settings
	settings = {'debug': true}
	
	# load player
	var player_res = preload('res://assets/creatures/player/Player.tscn')
	player = player_res.instance()


func goto_scene(path):
	print('go to scene: ', path)
	loader = ResourceLoader.load_interactive(path)
	#print(loader)
	if loader == null:
		#show_error()
		print('no loader created')
		return
	set_process(true)
	current_scene.queue_free()
	get_node('/root/').add_child(loading_screen)
	wait_frames = 1


func _process(delta):
	# disable _process when loading is done
	if loader == null:
		print('no loader setting to false')
		set_process(false)
		return
	# skip (first) frame to display loading before blocking
	if wait_frames > 0:
		#print('skipping this frame')
		wait_frames -= 1
		return
	var t = OS.get_ticks_msec()
	# time_max decides how long loading can block the thread
	while OS.get_ticks_msec() < t + time_max:
		#print('loading ...')
		# update loading
		var err = loader.poll()
		if err == ERR_FILE_EOF: # finish
			#print('finish!')
			var resource = loader.get_resource()
			loader = null  # stop in next call
			set_new_scene(resource)
			get_node('/root/LoadingScreen').set_visible(false)
			#print('new scene set')
			break
		elif err == OK:
			update_loading_screen(delta)
		else:  # real error
			print('error')
			print(err)
			loader = null
			break


func set_new_scene(scene_res):
	current_scene = scene_res.instance()
	get_node("/root/").add_child(current_scene)


func update_loading_screen(delta):
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	var loading_screen = get_node('/root/LoadingScreen')
	#print(loading_screen)
	#print('progress: ', progress*100)
	#print('in: ', delta)
	loading_screen.get_node('CenterContainer/Progress').set_value(progress*100)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	# seems like this is never called? still needed?
	print('_deferred_goto_scene() called')
	current_scene.free()
	# Load the new scene.
	var s = ResourceLoader.load(path)
	# Instance the new scene.
	current_scene = s.instance()
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)


func get_player():
	return self.player


func get_world():
	return self.world


func get_ui():
	return self.ui