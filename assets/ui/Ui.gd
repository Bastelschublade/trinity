extends Control

var panel_blue_res = preload('res://assets/ui/rpg/png/panel_blue.png')
var notification_res = preload('res://assets/ui/Notification.tscn')
var buttons = [null, null]
var cooldowns = [null, null]  # max cooldown time
var timers = [null, null]  # timer node contains current cd time
var cd_bars = [null, null]

onready var fps_label = get_node('FPS')
onready var target_frame = get_node('MarginContainer/MainContainer/TopContainer/TargetFrame/Target')
onready var player_frame = get_node('MarginContainer/MainContainer/TopContainer/PlayerFrame')
onready var settings = get_node('/root/Global').settings
onready var player = Global.get_player()


func _ready():
	target_frame.set_visible(false)
	cooldowns[0] = 1
	cooldowns[1] = 1
	timers[0] = get_node('MarginContainer/MainContainer/Actionbar/button_01/Timer')
	timers[1] = get_node('MarginContainer/MainContainer/Actionbar/button_02/Timer')
	cd_bars[0] = get_node('MarginContainer/MainContainer/Actionbar/button_01/MarginContainer/Cooldown')
	cd_bars[1] = get_node('MarginContainer/MainContainer/Actionbar/button_02/MarginContainer/Cooldown')
	


func update_target(obj=player.target):
	#print('new target: ', obj)
	var visible = false
	if not obj:
		target_frame.set_visible(visible)
		player.target = null
		return
	if obj is Creature:
		var name_label = target_frame.get_node('MarginContainer/VBoxContainer/Name')
		var health_bar = target_frame.get_node('MarginContainer/VBoxContainer/HealthBar')
		name_label.set_text(obj.creature_name)
		health_bar.set_value(obj.rel_health())
		visible = true
		player.target = obj
		if obj.rel_health() <= 0:
			target_frame.get_node('Background').set_texture(panel_blue_res)
	
	target_frame.set_visible(visible)
	if not visible:
		player.target = null


func update_player_frame():
	var player_h_bar = get_node('MarginContainer/MainContainer/TopContainer/PlayerFrame/MarginContainer/VBoxContainer/HealthBar')
	var player_p_bar = get_node('MarginContainer/MainContainer/TopContainer/PlayerFrame/MarginContainer/VBoxContainer/PowerBar')
	var p_h_rel = player.stats.rel_health()
	player_h_bar.set_value(p_h_rel)
	print('value set to: ', p_h_rel)
	player_p_bar.set_value(player.stats.rel_power())
	print('player hbar val: ', player_h_bar.get_value(), ' should be ', player.stats.rel_health())
	if player.stats.rel_health() <= 0:
		player_frame.get_node('Background').set_texture(panel_blue_res)

func _process(delta):
	if settings.get('debug', false) and delta > 0:
		fps_label.set_text(String(1/delta))
	if not self.player.dead:
		if Input.is_action_just_pressed('one'):
			_on_button_01_pressed()
		if Input.is_action_just_pressed('two'):
			_on_button_02_pressed()
		# update cds
		for i in range(len(timers)):
			var cd = timers[i].time_left
			cd_bars[i].set_value(cd/cooldowns[i]*100)


func _global_cd():
	for timer in timers:
		if timer.time_left < 1:
			timer.start(1)


func _on_button_01_pressed():
	if player.target:
		if timers[0].time_left > 0:
			notify('Noch nicht bereit')
			return
		if player.attack():
			timers[0].start(cooldowns[0])
			_global_cd()
	else:
		notify('Kein Ziel zum Angreifen.')


func _on_button_02_pressed():
	if timers[1].time_left > 0:
		notify('Noch nicht bereit')
		return
	player.block()
	timers[1].start(1)
	_global_cd()
	
	

func notify(text):
	var noti = notification_res.instance()
	noti.set_text(text)
	get_node('MarginContainer/MainContainer/TopContainer/NotificationFrame/List').add_child(noti)