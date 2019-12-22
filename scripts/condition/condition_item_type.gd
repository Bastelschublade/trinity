extends Condition
class_name ConditionItemType

export(String) var item_type
export(int) var item_amount = 1


func _ready():
	pass


func check():
	var matches = Global.player.inventory.get_items_by_type(item_type)
	return (len(matches) >= item_amount)
	# TODO: return default on exception?