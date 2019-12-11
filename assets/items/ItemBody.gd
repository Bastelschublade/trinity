extends RigidBody
class_name ItemBody

export(String) var item_alias = "item"
export(bool) var itembody_collectable = true  # can be set to false on instance, to avoid greefing

var meta = null

func _ready():
	meta = Global.itemdb.get_meta(item_alias)


func interact():
	print('iteract item body')
	Global.player.inventory.add_item(self.item_alias)
	self.queue_free()