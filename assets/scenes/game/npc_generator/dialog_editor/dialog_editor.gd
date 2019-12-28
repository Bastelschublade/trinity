extends Control

var node_spawn = Vector2(50, 50)
var node_res = {
	'talk': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/talk_node.tscn'),
	'answer': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/answer_node.tscn'),
	'condition': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/condition_node.tscn'),
	'quest': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/quest_node.tscn'),
	'action': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/action_node.tscn'),
	}


var connections = []
var nodes = {}
var nodes_counter = 0  # != len nodes != idx because removable
var data

onready var editor = get_node('Container/GraphEdit')
onready var start_node = editor.get_node('StartNode')

func _ready():
	start_node.id = 0
	nodes[start_node.id] = start_node


func _on_create_node_pressed(type):
	# create TalkNode
	nodes_counter += 1
	var node = node_res[type].instance()
	node.set_offset(node_spawn)
	node.id = int(nodes_counter)
	editor.add_child(node)
	nodes[node.id] = node




func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	# track connections
	editor.connect_node(from, from_slot, to, to_slot)
	print(editor.get_node(from).id)
	var c = [editor.get_node(from).id, from_slot, editor.get_node(to).id, to_slot]
	connections.append(c)
	print('connected and added to list: ', c) 
	# todo use set?



func _on_disconnection_request(from, from_slot, to, to_slot):
	print('disconnecting')
	print(connections)
	editor.disconnect_node(from, from_slot, to, to_slot)
	# find and remove connection:
	var keep_connections = []
	for c in connections:
		if not c == [editor.get_node(from).id, from_slot, editor.get_node(to).id, to_slot]:
			keep_connections.append(c)
			#connections.erase(c)
	connections = keep_connections
	print(connections)



func export():
	data = {'connections': connections}
	data['nodes'] = {}
	# todo: safe connections in each node (from)?
	for key in nodes.keys():
		print(key)
		data['nodes'][key] = nodes[key].export(connections)
		#data['nodes'][key]['ports'] = {}
		#for pn in nodes[key].port_names_right:
		#	if pn:
	#			data['nodes'][key]['ports'][pn] = []
	#print(data['nodes'])
	#for c in connections:
	#	if nodes[c[0]].port_names_right[c[1]]:
#			data['nodes'][c[0]]['ports'][c[1]].append([c[2],c[3]])
#	print(data['nodes'])
	$SaveWindow.popup()


func _on_SaveWindow_confirmed():
	print('confirmed')
	var file_name = $SaveWindow.current_path
	#print($SaveWindow.current_path)
	var file = File.new()
	file.open(file_name, File.WRITE)
	file.store_string(to_json(data))
	file.close()
	$SaveWindow.hide()


func _on_export_pressed():
	self.export()


func remove_node(node):
	print('remove node: ', node.id)
	# remove all connections with this node
	var keep_connections = []
	for c in connections:
		if c[0] == node.id or c[2] == node.id:
			print('found connection to remove')
		else:
			keep_connections.append(c)
			connections.erase(c)
	connections = keep_connections
	nodes.erase(node.id)
	node.queue_free()