extends GameObject
class_name door

export(bool) var open = false
export(bool) var locked = false

var close_snd = preload('res://assets/sounds/interactions/door_close.wav')
var open_snd = preload('res://assets/sounds/interactions/door_open.wav')
var busy = false
onready var anim_player = get_node('AnimationPlayer')
onready var snd_player = get_node('AudioPlayer')


func _ready():
	pass


func interact():
	if locked:
		print('locked')
		return false
	if busy:
		return false
	busy = true
	if open:
		print('close the gate')
		#snd_player.set_stream(close_snd)
		#snd_player.play()
		anim_player.play('Close')
		object_tooltip = 'Tor öffnen'
		open = false
	else:
		print('open the gate')
		#snd_player.set_stream(open_snd)
		#snd_player.play()
		anim_player.play('Open')
		object_tooltip = 'Tor schließen'
		open = true


func _on_AnimationPlayer_animation_finished(anim_name):
	busy = false


func _ready():
	pass
