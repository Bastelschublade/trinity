extends Control

var node_spawn = Vector2(50, 50)
var node_res = {
	'talk': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/talk_node.tscn'),
	'answer': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/answer_node.tscn'),
	'condition': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/condition_node.tscn'),
	'quest': preload('res://assets/scenes/game/npc_generator/dialog_editor/nodes/quest_node.tscn'),
	}

onready var editor = get_node('Container/GraphEdit')

func _ready():
	pass


func _on_create_node_pressed(type):
	# create TalkNode
	var node = node_res[type].instance()
	node.set_offset(node_spawn)
	editor.add_child(node)


func _on_GraphNode_resize_request(new_minsize):
	pass # Replace with function body.


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	editor.connect_node(from, from_slot, to, to_slot)



