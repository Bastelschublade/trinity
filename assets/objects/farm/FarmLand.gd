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


func create_crop(crop_res_path):
	var crop_res = load(crop_res_path)
	crop = crop_res.instance()
	get_node('Crop').add_child(crop)
	Global.ui.close_mouse_menu()
	# todo get scene from item


func harvest_crop():
	# todo give player item
	crop.queue_free()  # removed node and obj?
	Global.ui.notify('Pflanze geerntet')
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
		# TODO: parse user inventar instead of hardcode, and remove on click.. 
		var menu_data = [
			{'text': 'Weizen säen', 'callback': "create_crop", 'data': 'res://assets/objects/farm/crops/WheatX.tscn'},
			{'text': 'Karotte pflanzen', 'callback': "create_crop", 'data': 'res://assets/objects/farm/crops/CarrotX.tscn'},
			{'text': 'Erdbeere pflanzen', 'callback': "create_crop", 'data': 'res://assets/objects/farm/crops/StrawberryX.tscn'},
			]
		Global.ui.mouse_menu(self, menu_data)
	elif crop.ripe:
		var menu_data = [{'text': 'Ernten', 'callback': 'harvest_crop'}]
		Global.ui.mouse_menu(self, menu_data)


func menu_func():
	Global.ui.close_mouse_menu()