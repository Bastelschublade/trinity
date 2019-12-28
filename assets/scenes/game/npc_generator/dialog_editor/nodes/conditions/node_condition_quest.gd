extends NodeCondition


func _ready():
	self.condition_name = 'Quest Status'
	for s in ['Nicht', 'Abgelehnt', 'Aktiv', 'Erfüllt', 'Abgeschlossen']:
		get_node('state/select').add_item(s, -1)
	for s in ['Mindestens', 'Exakt', 'Höchstens']:
		get_node('check/select').add_item(s, -1)


func export():
	var data = {}
	data['quest_alias'] = get_node('quest/LineEdit').text
	data['quest_state'] = get_node('state/select').get_selected_id()
	data['quest_check'] = get_node('check/select').get_selected_id()
	return data