extends RigidBody
class_name ItemBody

export(String) var item_alias = "item"

var meta = null

func _ready():
	meta = Global.itemdb.get_meta(item_alias)
