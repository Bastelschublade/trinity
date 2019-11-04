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

onready var player = get_node('/root/Level/Character')


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
		print('receive item', choice['receive_item'])
	if 'provide_item' in choice:
		player.inventory.remove_items(choice['provide_item'])
	if 'next_view' in choice:
		npc.npc_next_view = choice['next_view']
	if 'exit' in choice:
		queue_free()


func check_conditions(conditions):
	print('checking conditions')
	var fulfill = false
	for condition in conditions:
		var fulfill_all = true
		for key in condition:
			print(key)
			var val = condition[key]
			# todo add all cases
			if key == 'has_item':
				if !player.inventory.has_items(val):
					fulfill_all = false
		# any condition where every {} is fullfilled -> true
		if fulfill_all:
			fulfill = true
	return fulfill
	

func finish_talk():
	for ans in choices:
		var ansButton = Button.new()
		var fulfill = true
		# check visibility
		if 'conditions' in ans:
			fulfill = check_conditions(ans['conditions'])
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
		var player_pos = get_node('/root/Level/Character').get_global_transform().origin
		if start_pos.distance_to(player_pos) > quit_distance:
			queue_free()