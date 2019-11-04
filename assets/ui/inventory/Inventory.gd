extends HBoxContainer

onready var item_list = get_node('ListPage/MarginContainer/ScrollContainer/ItemList')
onready var item_details = get_node('ItemInspect/ItemDetails')

var list_item_scene = preload("res://assets/ui/inventory/ListItem.tscn")


func find_item(item_id):
	for item in item_list.get_children():
		if item.get_node('Slot/Id').get_text() == String(item_id):
			#print('item found')
			return item
	return false


func has_items(dict):
	print(dict)
	# returns true or false for dict with item ids and amounts
	for iid in dict:
		var item_in_inv = false
		for item in item_list.get_children():
			var cur_id = item.get_node('Slot/Id').get_text()
			print('id compare: ', cur_id, ' ', iid)
			if String(cur_id) == String(iid):
				item_in_inv = true
				var cur_am = int(item.get_node('Slot/Amount').get_text())
				print('am compare: ', cur_am, ' ', dict[iid])
				if cur_am < int(dict[iid]):
					print('item amount to low: ', iid, ' ', cur_am)
					return false
		if !item_in_inv:
			print('item not in inv: ', iid)
			return false
	return true


func remove_items(dict):
	for iid in dict:
		for item in item_list.get_children():
			if String(iid) == item.get_node('Slot/Id').get_text():
				var cur_am = int(item.get_node('Slot/Amount').get_text())
				var new_am = cur_am - int(dict[iid])
				if new_am < 0:
					print('Bug: item removed that not exists')
					new_am = 0
				if new_am == 0:
					item.queue_free()
				else:
					item.get_node('Slot/Amount').set_text(String(new_am))


func add_item(item_id):
	#var item = object.get_node('Item')
	var existing_item = find_item(item_id)
	if existing_item:
		var amount = existing_item.get_node('Slot/Amount')
		amount.set_text(String(int(amount.get_text()) + 1))
		return
		
	var item_db = get_node('/root/Level').item_db
	var list_item = list_item_scene.instance()
	var item = item_db[String(item_id)]
	# set icon, name and desc
	var icon = load(item['icon'])
	list_item.get_node('Slot/Icon').set('texture', icon)
	list_item.get_node('Slot/Id').set_text(String(item_id))
	list_item.get_node('Slot/Amount').set_text(String(1))
	list_item.get_node('ListInfo/ItemName').set_text(item['name'])
	item_list.add_child(list_item)
	
	
func _ready():
	pass