extends Control

onready var fps_label = get_node('FPS')
onready var target_frame = get_node('MarginContainer/MainContainer/TopContainer/TargetFrame')
onready var settings = get_node('/root/Global').settings
onready var player = get_node('/root/Level/Character')

var notification_res = preload('res://assets/ui/Notification.tscn')


func _ready():
	target_frame.set_visible(false)


func update_target(obj):
	#print('new target: ', obj)
	var visible = false
	if not obj:
		target_frame.set_visible(visible)
		return
	if obj is NPC or obj is Animal:  # todo parent class creature
		var name_label = target_frame.get_node('MarginContainer/VBoxContainer/Name')
		var health_bar = target_frame.get_node('MarginContainer/VBoxContainer/HealthBar')
		name_label.set_text(obj.name)
		health_bar.value = obj.rel_health()
		visible = true
		player.target = obj
	
	target_frame.set_visible(visible)
	if not visible:
		player.target = null

func _process(delta):
	if settings.get('debug', false):
		fps_label.set_text(String(1/delta))
	if Input.is_action_just_pressed('one'):
		_on_button_01_pressed()
	if Input.is_action_just_pressed('two'):
		_on_button_02_pressed()


func _on_button_01_pressed():
	if player.target:
		player.attack()
	else:
		notify('Kein Ziel zum Angreifen.')


func _on_button_02_pressed():
	pass
	

func notify(text):
	var noti = notification_res.instance()
	noti.set_text(text)
	get_node('MarginContainer/MainContainer/TopContainer/NotificationFrame/List').add_child(noti)