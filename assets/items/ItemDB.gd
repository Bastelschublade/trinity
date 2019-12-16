extends Node
class_name ItemDB

var items = {}
var icon_default = preload('res://assets/items/icons/default.png')
var body_default = preload('res://assets/items/bodies/default.tscn')


func _ready():
	print('init itemdb')
	for item in self.get_children():
		# load defaults
		if not item.item_alias:
			item.item_alias = item.name
		if not item.item_icon:
			item.item_icon = load('res://assets/items/icons/' + item.item_alias + '.png')
		if not item.item_icon:
			print('no icon found for: ', item.item_alias)
			item.item_icon = icon_default
		if not item.item_body:
			item.item_body = load('res://assets/items/bodies/' + item.item_alias + '.tscn')
		if not item.item_body:
			print('no body found for: ', item.item_alias)
			item.item_body = body_default
		self.items[item.item_alias] = item


func get_item(alias):
	return self.items[alias]
	