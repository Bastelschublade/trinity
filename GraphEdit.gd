extends GraphEdit

func _ready():
	pass


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	print('request to connect: ', from_slot)
	connect_node(from, from_slot, to, to_slot)
	pass # Replace with function body.
