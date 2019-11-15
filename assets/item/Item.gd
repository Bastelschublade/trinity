extends Spatial
class_name Item

# class constants
#const SLOTS = ["", "OFFHAND", "HEAD", "CHEST", "PANTS", "BOOTS", "TRINKET"]
enum SLOTS {MAINHAND, OFFHAND, HEAD}
# editable parameters
export(String) var item_id

# initials
#var slot_keys = SLOTS.keys()
var body
var data

func _ready():
	var item_db = get_node('/root/Global').item_db
	data = item_db[self.item_id]
	print('item ready')


func create_body():
	var body_res = load('res://assets/item/' + data['type'] + data['fname'] + 'body.tscn')
	body = body_res.instance()


func interact():
	print('item collect itself')
	var inventory = get_node('/root/Level/Ui/GameMenu/TabContainer/Inventar/Inventory')
	inventory.add_item(self.item_id)
	self.queue_free()