extends NodeCondition

func _ready():
	for t in ['Health', 'Attack', 'Power', '...']: # TODO: read from players stats class
		get_node('stat/select').add_item(t, -1)
	for t in ['Mindestens', 'Exakt (ohne ,)', 'Maximal']:
		get_node('check/select').add_item(t, -1)
