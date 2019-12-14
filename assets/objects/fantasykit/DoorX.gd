extends GameObject

export(bool) var open = false
export(bool) var locked = false

var close_snd = preload('res://assets/sounds/interactions/door_close.wav')
var open_snd = preload('res://assets/sounds/interactions/door_open.wav')
var busy = false
onready var anim_player = get_node('AnimationPlayer')
onready var snd_player = get_node('AudioPlayer')


func _ready():
	object_tooltip = 'Tür öffnen'


func interact():
	print('door clicked')
	if locked:
		print('locked')
		return false
	if busy:
		print('busy')
		return false
	busy = true
	if open:
		print('close the gate')
		#snd_player.set_stream(close_snd)
		#snd_player.play()
		anim_player.play('Close')
		object_tooltip = 'Tür öffnen'
		open = false
	else:
		print('open the gate')
		#snd_player.set_stream(open_snd)
		#snd_player.play()
		anim_player.play('Open')
		object_tooltip = 'Tür schließen'
		open = true


func _on_AnimationPlayer_animation_finished(anim_name):
	busy = false
