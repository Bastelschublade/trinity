extends NodeCondition

func _ready():
	self.condition_name = 'Check Stats'
	for t in ['Health', 'Attack', 'Power', '...']: # TODO: read from players stats class
		get_node('stat/select').add_item(t, -1)
	for t in ['Mindestens', 'Gerundet', 'Maximal']:
		get_node('check/select').add_item(t, -1)

func export():
	var data = {}
	data['stat'] = get_node('stat/select').get_selected_id()
	data['value'] = get_node('value/SpinBox').value
	data['check'] = get_node('check/select').get_selected_id()
	return data