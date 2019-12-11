extends Node
class_name ItemDB

var items = {}

func _ready():
	print('init itemdb')
	for item in self.get_children():
		self.items[item.item_alias] = item


func get_item(alias):
	return self.items[alias]
	