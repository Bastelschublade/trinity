extends Condition
class_name ConditionItem

export(String) var item_alias
export(int) var item_amount = 1

func _ready():
	pass

func check():
	return Global.player.inventory.has_items({item_alias: item_amount})
	