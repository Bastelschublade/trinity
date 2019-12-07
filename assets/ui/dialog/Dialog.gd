extends Control

# Declare member variables here. Examples:
var chars = 0
var step = 2
var typing = true
var views
var answer_pad = 5
var text_row_h = 10
var label
var answerbox
var choices
var start_pos
var quit_distance = false
var npc

onready var player = Global.player
onready var ui = Global.ui


func setup_view(view):
	label.set_bbcode(view['text'])
	label.set_visible_characters(0)
	typing = true
	for choice in answerbox.get_children():
		choice.queue_free()
	choices = view['choices']


func answer(choice):
	if 'view' in choice:
		setup_view(views[choice['view']])
	if 'receive_item' in choice:
		print('receiving item')
		player.inventory.add_item(choice['receive_item'])
		ui.notify('Gegenstand erhalten')
	if 'provide_item' in choice:
		player.inventory.remove_items(choice['provide_item'])
		ui.notify('Gegenstand abgegeben')
	if 'next_view' in choice:
		npc.npc_next_view = choice['next_view']
	if 'set_flag' in choice:
		player.set_flag(choice['set_flag'])
	if 'rem_flag' in choice:
		player.set_flag(choice['set_flag'])
	if 'emit_signal' in choice:
		var events = get_node('/root/Events')
		print('emit signal in world')
		events.emit_signal(choice['emit_signal']['signal'], [choice['emit_signal']['data']])
	if 'exit' in choice:
		queue_free()


func check_conditions(conditions):
	# recursive decisions for nested "and"/"or" logic
	# for multiple keys its always "and"
	var each = (conditions.get('logic', 'and') == 'and')
	for key in conditions:
		if key == 'logic':
			continue
		elif key == 'condition':
			var c = check_conditions(conditions[key])
			if each != c:
				return c
		elif key == 'has_item':
			var c = player.inventory.has_items(conditions[key])
			if each != c:
				return c
		elif key == 'rep_min':
			var c = (npc.reputation >= conditions[key])
			if each != c:
				return c
		elif key == 'has_flag':
			var c = player.has_flag(conditions[key])
			if each != c:
				return c
	return each


func finish_talk():
	for ans in choices:
		var ansButton = Button.new()
		var fulfill = true
		# check visibility
		if 'condition' in ans:
			fulfill = check_conditions(ans['condition'])
		if !fulfill:
			var show_disabled = ans.get('show_disabled', false)
			if !show_disabled:
				continue
			ansButton.set('disabled', true)
		ansButton.set_text(ans['text'])
		ansButton.set("flat", true)
		ansButton.set("align", 0)
		ansButton.set("custom_colors/font_color", "#d8ca83")
		ansButton.set("custom_colors/font_color_hover", "#ffffff")
		ansButton.connect("pressed", get_node("."), "answer", [ans])
		answerbox.add_child(ansButton)
		

# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("DialogWindow/TextBox/TextLabel")
	answerbox = get_node("DialogWindow/AnswerBox/MarginContainer")
	#label.set_bbcode(text)
	setup_view(self.views[self.npc.npc_next_view])


func _on_Timer_timeout():
	# Increase the displayed chars to create type effect
	if !typing:
		return
	var visible = label.get_visible_characters() + step
	label.set_visible_characters(visible)
	if visible >= len(label.text):
		finish_talk()
		typing = false


func _on_TextureButton_pressed():
	# quit button probably just hide? or use timer to remove after inactive.
	#get_node().visi
	queue_free()


func _physics_process(delta):
	if quit_distance:
		var player_pos = Global.player.get_global_transform().origin
		if start_pos.distance_to(player_pos) > quit_distance:
			queue_free()