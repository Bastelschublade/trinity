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
