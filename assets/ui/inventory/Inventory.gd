extends HBoxContainer

export(float) var max_weight = 30

onready var item_list = get_node('ListPage/MarginContainer/VBoxContainer/ScrollContainer/ItemList')
onready var weight_box = get_node('ListPage/MarginContainer/VBoxContainer/WeightBox')
onready var weight_bar = get_node('ListPage/MarginContainer/VBoxContainer/WeightBar')
onready var item_details = get_node('ItemInspect/Details')
onready var player = Global.player
onready var itemdb = Global.itemdb


var list_item_res = preload("res://assets/ui/inventory/ListItem.tscn")
var item_details_res = preload("res://assets/ui/inventory/ItemDetails.tscn")
var weight = 0
var gold = 0
var rations = 0
var items = {}  # dict: {'id_name1': 'count'}
#var icons = {}  # dict: {id: iconpath, id2: iconpath2}
#var item_db


func get_item_count(alias):
	return items.get(alias, 0)


func get_item(alias):
	return itemdb.get_item(alias)


func has_item(alias):
	""" checks if an item is in users inventory without 
	checking amount or anything else.
	"""
	return (alias in items)


func has_items(check_items):
	""" gets a dict {alias: count} to check if a player has enough of all items
	"""
	# returns true or false for dict with item ids and amounts
	for alias in check_items:
		if check_items[alias] > items.get(alias, 0):
			return false
	return true


func get_items_by_type(key):
	""" checks the meta data from itemdb of an item for key in item.types{}.
	Returns an dict {alias: count} of matches
	"""
	var matches = {}
	for alias in items:
		var item = itemdb.get_item(alias)
		if key in item.types:
			matches[alias] = items[alias]
	return matches


func remove_item(alias):
	""" shortcut for remove_items({alias: 1})?
	"""
	return self.remove_items({alias: 1})


func remove_items(rem_items):
	""" takes dict {alias: count} and removes that amount from inventory.
	if not enough available, nothing is removed and false is returned.
	"""
	var new_amounts = {}
	# check inventory for items
	for alias in rem_items:
		var rem = rem_items[alias]
		var new = items.get(alias, 0) - rem
		if new < 0:
			print('not removable')
			return false
		new_amounts[alias] = new
		print('ready to removed')
	# if passed, set to new values
	# items.update(new_amounts)  # NOTE: method not defined
	for alias in new_amounts:
		items[alias] = new_amounts[alias]
		print('removed')
	update_inventory()
	return true


func add_items(add_items):
	""" takes dict {alias: count} of items to add to players inventory.
	"""
	for alias in add_items:
		items[alias] = items.get(alias, 0) + add_items[alias]
	update_inventory()


func add_item(alias, count=1):
	""" adds 1 (or count) items from alias to the inventory
	"""
	items[alias] = items.get(alias, 0) + count
	update_inventory()


func create_list_item(item, count):
	var li = list_item_res.instance()
	li.get_node('Layout/Slot/Icon').set('texture', item.item_icon)
	#li.get_node('Layout/Slot/Id').set_text(String(id))
	li.get_node('Layout/Slot/Amount').set_text(String(count))
	li.get_node('Layout/ListInfo/ItemName').set_text(item.item_name)
	var tags = li.get_node('Layout/ListInfo/InfoTags')
	tags.get_node('Price').set_text(String(item.item_price))
	tags.get_node('Weight').set_text(String(item.item_weight))
	return li


func update_inventory():
	""" removes empty entries, checks for references, recalculate weight and stats, updates ui.
	"""
	print('updating inventory')
	# clear everything
	weight = 0
	for c in item_list.get_children():
		print('removing item..')
		c.queue_free()
	
	# update for each item
	for alias in items:
		var cnt = items[alias]
		if cnt == 0:
			items.erase(alias)
			continue
		elif cnt < 0:
			print('Negative item count! BUG!')
		# update weight
		weight += itemdb.get_item(alias).item_weight * cnt
		# create list item
		var li = create_list_item(itemdb.get_item(alias), items[alias])
		li.connect("pressed", self, "update_details", [alias])
		item_list.add_child(li)
	
	# update weight bar
	weight_box.set_visible(true)
	weight_box.get_node('WeightLabel').set_text(String(weight) + '/' + String(max_weight))
	weight_bar.set_visible(true)
	weight_bar.set_value(self.weight/self.max_weight*100)


func update_details(id):
	print('update details')
	var item = itemdb.get_item(id)

	# add item details
	var this_details = get_node('ItemInspect/Details/ItemDetails')
	this_details.set_visible(true)
	this_details.get_node('IconLarge').set('texture', item.item_icon)
	this_details.get_node('IconLarge').set('rect_size', Vector2(100,100))
	this_details.get_node('ItemName').set_text(item.item_name)
	this_details.get_node('ItemDesc').set_text(item.item_text)
	var equip_button = this_details.get_node('ItemButtons/Equip')
	if "Weapon" in item.types:
		equip_button.set_visible(true)
		equip_button.disconnect("pressed", self, "_on_equip_pressed")
		equip_button.connect("pressed", self, "_on_equip_pressed", [item])
	else:
		equip_button.set_visible(false)


func _ready():
	self.add_item("carrot")


func _on_equip_pressed(item):
	print('pressed: ', item.item_alias)
	self.remove_items({item.item_alias: 1})
	var it_res = item.item_body
	var it = it_res.instance()
	if player.gear["mainhand"].get('item', false):
		add_item(player.gear['mainhand']['item'].item_id)
	player.equip_item(it)
	get_node('ItemInspect/Details/ItemDetails').set_visible(false)
	#print(it.get_node('Body'))
	#it.create_body()
