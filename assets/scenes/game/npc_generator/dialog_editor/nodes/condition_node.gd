extends MyGraphNode

onready var conditions_list = get_node('Conditions')
onready var options = get_node('ConditionSelect/select')

var port_names_right = ['true', 'false']
var selection = 0

func _ready():
	#options.add_item('', -1)
	for cond in conditions_list.get_children():
		options.add_item(cond.condition_name, -1)
	self.type = 'condition'



func _on_select_condition(id):
	for c in conditions_list.get_children():
		c.set_visible(false)
	conditions_list.get_child(id).set_visible(true)
	self.selection = id


func export(cons=false):
	var data = .export(cons)
	var id = options.get_selected_id()
	data['sub_id'] = selection
	data['sub_name'] = options.get_item_text(selection)
	data['sub_data'] = conditions_list.get_child(selection).export()
	return data