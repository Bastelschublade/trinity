extends Spatial
class_name FarmLand

#export var field_state = 0  # 0 leer, 1 bepflanzt, 2 fertig
var crop = false


func _ready():
	pass


func get_crop():
	return self.crop


func set_crop(c):
	self.crop = c


func create_crop(data):
	print(data)
	Global.player.inventory.remove_items({data['id']: 1})
	crop = data['res'].instance()
	get_node('Crop').add_child(crop)
	Global.ui.close_mouse_menu()
	# todo get scene from item


func harvest_crop():
	# todo give player item
	crop.queue_free()  # removed node and obj?
	Global.player.inventory.add_items({crop.harvest_item: crop.harvest_num})
	crop = false
	Global.ui.close_mouse_menu()
	

func get_tooltip():
	if not crop:
		return 'Acker: Leer'
	if crop.ripe:
		return crop.crop_name + ': Reif'
	else:
		return crop.crop_name + ': Wächst'


func interact():
	# search inventory for valid crops
	print('show menu')
	if not crop:
		var available_seeds = Global.player.inventory.get_items_by_type('Seed') 
		var menu_data = []
		for id in available_seeds:
			var idb = Global.player.inventory.itemdb
			var item_seed = idb.get_item(id).types['Seed']
			var text = item_seed.plant_button
			var res = item_seed.crop
			menu_data.append({'text': text, 'callback': "create_crop", 'data': {'res': res, 'id': id}})
		Global.ui.mouse_menu(self, menu_data)
	elif crop.ripe:
		var menu_data = [{'text': 'Ernten', 'callback': 'harvest_crop'}]
		Global.ui.mouse_menu(self, menu_data)


func menu_func():
	Global.ui.close_mouse_menu()