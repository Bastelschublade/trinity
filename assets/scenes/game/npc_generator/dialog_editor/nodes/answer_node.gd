extends MyGraphNode

func _ready():
	var select = get_node('SpecialRow/select')
	for t in ['', 'Quest', 'Handel', 'Kampf', 'Info']:
		select.add_item(t, -1)

