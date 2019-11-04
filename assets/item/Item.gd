extends Node
class_name Item

export(int) var item_id
export(String) var item_name
export(String, FILE, "*.png") var item_icon
export(String) var item_tooltip
export(float) var item_weight
export(bool) var item_saleable
export(float) var item_price

var icon

func _ready():
	icon = load(item_icon)
