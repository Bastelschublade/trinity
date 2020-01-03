extends Control

func _ready():
	pass


func _on_NewButton_pressed():
	print('starting new game')
	Global.goto_scene("res://assets/scenes/game/CharacterGenerator.tscn")


func _on_QuitButton_pressed():
	print('quit pressed')
	get_tree().quit()


func _on_TextureButton2_pressed():
	var player_res = load("res://assets/creatures/player/Player.tscn")
	Global.player = player_res.instance()
	Global.player.get_node('target/Camera').manually_init()
	Global.goto_scene("res://World.tscn")


func _on_create_dialog_pressed():
	print('starting editor')
	Global.goto_scene('res://assets/scenes/game/npc_generator/dialog_editor/dialog_editor.tscn')


func _on_export_itemdb_pressed():
	Global.itemdb._export()


func _on_skin_editor_pressed():
	Global.goto_scene('res://assets/scenes/game/npc_generator/skin_editor/skin_editor.tscn')
