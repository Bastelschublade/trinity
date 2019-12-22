extends NodeCondition


func _ready():
	for s in ['Nicht', 'Abgelehnt', 'Aktiv', 'Erfüllt', 'Abgeschlossen']:
		get_node('state/select').add_item(s, -1)
	for s in ['Mindestens', 'Exakt', 'Höchstens']:
		get_node('check/select').add_item(s, -1)
