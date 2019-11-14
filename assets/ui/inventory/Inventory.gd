extends HBoxContainer

onready var item_list = get_node('ListPage/MarginContainer/ScrollContainer/ItemList')
onready var item_details = get_node('ItemInspect/Details')


var list_item_res = preload("res://assets/ui/inventory/ListItem.tscn")
var item_details_res = preload("res://assets/ui/inventory/ItemDetails.tscn")
var weight = 0
var items = {}
var icons = {}
var item_db


func find_item(item_id):
	for item in item_list.get_children():
		if item.get_node('Layout/Slot/Id').get_text() == String(item_id):
			#print('item found')
			return item
	return false


func has_items(dict):
	print(dict)
	# returns true or false for dict with item ids and amounts
	for iid in dict:
		var item_in_inv = false
		for item in item_list.get_children():
			var cur_id = item.get_node('Layout/Slot/Id').get_text()
			print('id compare: ', cur_id, ' ', iid)
			if String(cur_id) == String(iid):
				item_in_inv = true
				var cur_am = int(item.get_node('Layout/Slot/Amount').get_text())
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
			if String(iid) == item.get_node('Layout/Slot/Id').get_text():
				var cur_am = int(item.get_node('Layout/Slot/Amount').get_text())
				var new_am = cur_am - int(dict[iid])
				if new_am < 0:
					print('Bug: item removed that not exists')
					new_am = 0
				if new_am == 0:
					item.queue_free()
				else:
					item.get_node('Layout/Slot/Amount').set_text(String(new_am))


func add_item(item_id):
	#var item = object.get_node('Item')
	items[item_id] = items.get(item_id,0) + 1
	print('item added to inventory: ', item_id, '->', items[item_id])
	if not item_id in icons:
		print('loading icon')
		icons[item_id] = load("res://assets/item/" + item_db[item_id]["type"] + "/" + item_db[item_id]["fname"] + "/icon.png")
	update_list()
	
	# pass details to button callback
	#item_list.add_child(list_item)


func update_details(id):
	var data = item_db[id]
	var view = get_node("ItemInspect/Details/ItemDetails")
	view.set_visible(true)
	# add item details
	var this_details = get_node('ItemInspect/Details/ItemDetails')
	this_details.get_node('IconLarge').set('texture', icons[id])
	this_details.get_node('IconLarge').set('rect_size', Vector2(100,100))
	this_details.get_node('ItemName').set_text(String(data['name']))
	this_details.get_node('ItemDesc').set_text(String(data.get('text', "")))
	if data['type'] == 'weapon':
		print('add equip button')
	
	
func update_list():
	print('updating list')
	self.weight = 0
	# clean up old nodes
	for c in item_list.get_children():
		print('removing item..')
		c.queue_free()
	# create new nodes
	for id in items:
		print('creating item')
		var data = item_db[id]
		var li = list_item_res.instance()
		
		# set icon, name and desc
		if not id in icons:
			icons[id] = load('res://assets/item/' + data.get('type', 'stuff') + data['fname'] + 'icon.png')
		li.get_node('Layout/Slot/Icon').set('texture', icons[id])
		li.get_node('Layout/Slot/Id').set_text(String(id))
		li.get_node('Layout/Slot/Amount').set_text(String(items[id]))
		li.get_node('Layout/ListInfo/ItemName').set_text(data['name'])
		var tags = li.get_node('Layout/ListInfo/InfoTags')
		tags.get_node('Price').set_text(String(data.get('price', 0)))
		tags.get_node('Weight').set_text(String(data.get('weight', 0)))
		self.weight += float(data.get('weight', 0))
		li.connect("pressed", get_node('.'), "update_details", [id])
		item_list.add_child(li)


func _ready():
	item_db = get_node("/root/Global").item_db