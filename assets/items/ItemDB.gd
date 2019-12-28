extends Node
class_name ItemDB

export(String, FILE) var export_file_json = 'res://tmp/itemdb.json'
export(String, FILE) var export_file_md = 'res://tmp/itemdb.md'
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


func _export():
	var data = {}
	for item in self.get_children():
		data[item.name] = item._export()
	var data_file = File.new()
	data_file.open(export_file_json, File.WRITE)
	data_file.store_string(to_json(data))
	data_file.close()
	print('file:', data_file.get_path())
	var md = '> Diese Seite ist [[automatisch generiert|DevTools]] und enthält eine Liste aller Items die bereits im Spiel sind. Für eine Anleitung zum Erstellen bzw. zum Konzept siehe [[Item]].\n\n'
	for k in data:
		var i = data[k]
		var icon_snippet = '<img src="https://github.com/lukruh/trinity/raw/master/assets/items/icons/' + k + '.png" align="left" height="64" width="64" >'
		var s = '### ' + i['name'] + '\n' + icon_snippet + 'alias: ' + k + '\n\n' + i['text'] + '\n\n'
		md += s
	var wiki_file = File.new()
	wiki_file.open(export_file_md, File.WRITE)
	wiki_file.store_string(md)