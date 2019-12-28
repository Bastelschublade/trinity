extends MyGraphNode


var port_names_right = ['talks', 'actions', 'checkpoint']  
# should match port numbers, should be unique per type

onready var select = get_node('SpecialRow/select')


func _ready():
	self.type = 'answer'
	for t in ['', 'Quest', 'Handel', 'Kampf', 'Info']:
		select.add_item(t, -1)

func export(cons=false):
	var data = .export(cons)
	#data['id'] = self.id
	#data['type'] = self.type
	data['text'] = get_node('TextRow/LineEdit').text
	data['exit'] = get_node('ExitRow/CheckBox').pressed
	#data['offset'] = self.get('offset')
	"""
	if not cons:
		return data
	data['ports'] = {}
	for c in cons:
		if c[0] != self.id:
			print('not me')
			continue
		var pn = port_names_right[c[1]]
		print('port: ', c[1], ' ', pn)
		if not pn in data['ports']:
			data['ports'][pn] = []
		data['ports'][pn].append([c[2], c[3]])
	"""
	return data
		
