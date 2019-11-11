extends Control

onready var fps_label = get_node('FPS')


func _ready():
	pass


func _process(delta):
	fps_label.set_text(String(1/delta))