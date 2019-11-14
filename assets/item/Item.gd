extends Spatial
class_name Item

export(String) var item_id

var body
var data

func _ready():
	var item_db = get_node('/root/Global').item_db
	data = item_db[self.item_id]


func create_body():
	var body_res = load('res://assets/item/' + data['type'] + data['fname'] + 'body.tscn')
	body = body_res.instance()


func interact():
	print('item collect itself')
	var inventory = get_node('/root/Level/Ui/GameMenu/TabContainer/Inventar/Inventory')
	inventory.add_item(self.item_id)
	self.queue_free()