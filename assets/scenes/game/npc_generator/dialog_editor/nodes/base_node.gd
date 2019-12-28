extends GraphNode
class_name MyGraphNode

var id
var type = 'none'


func _ready():
	pass


func _on_close_request():
	get_parent().get_parent().get_parent().remove_node(self)


func export(cons=false):
	var data = {}
	data['id'] = self.id
	data['type'] = self.type
	data['offset'] = self.get('offset')
	if not cons:
		return data
	# select related connections
	data['ports'] = {}
	for c in cons:
		if c[0] != self.id:
			continue
		var pn = self.port_names_right[c[1]]
		print('port: ', c[1], ' ', pn)
		if not pn in data['ports']:
			data['ports'][pn] = []
		data['ports'][pn].append([c[2], c[3]])
	return data