extends Control

func _ready():
	pass


func _on_NewButton_pressed():
	print('starting new game')
	Global.goto_scene("res://World.tscn")


func _on_QuitButton_pressed():
	print('quit pressed')
	get_tree().quit()
