extends MyGraphNode

onready var conditions_list = get_node('Conditions')
onready var options = get_node('ConditionSelect/select')


func _ready():
	#options.add_item('', -1)
	for cond in conditions_list.get_children():
		options.add_item(cond.condition_name, -1)



func _on_select_condition(id):
	for c in conditions_list.get_children():
		c.set_visible(false)
	conditions_list.get_child(id).set_visible(true)
		
