extends Node
class_name Item

# class constants
#const SLOTS = ["", "OFFHAND", "HEAD", "CHEST", "PANTS", "BOOTS", "TRINKET"]
#enum SLOTS {MAINHAND, OFFHAND, HEAD}
# editable parameters
#export(String) var item_id
export(String) var item_name = "Gegenstand"
export(float) var item_weight = 0
export(float) var item_price = 0  # <0 = not sellable
export(bool) var item_stackable = true
export(String, MULTILINE) var item_text = "Beschreibung"

# optional
#export(Texture) var item_icon
#export(PackedScene) var item_body
#export(String) var item_alias
var item_icon
var item_body
var item_alias

# initials
#var slot_keys = SLOTS.keys()
var body = null
#var allowed_types = [Weapon, Food, Seed]
var types = {} # 'type': ref to instance


func _ready():
	var item_db = Global.item_db
	for c in self.get_children():
		# TODO: make this generic for all (or selected) types? use classes as keys?
		if c is Equip:
			types["Equip"] = c
		elif c is Weapon:  # check which behaviour is wanted.. is weapon also returned as equip?
			types["Weapon"] = c
		elif c is Food:
			types["Food"] = c
		elif c is Seed:
			types["Seed"] = c


func create_body():
	#var body_res = load('res://assets/item/' + data['type'] + data['fname'] + 'body.tscn')
	#body = body_res.instance()
	pass

func interact():
	#print('item collect itself')
	var inventory = get_node('/root/World/Ui/GameMenu/TabContainer/Inventar/Inventory')
	inventory.add_item(self.item_id)
	self.queue_free()