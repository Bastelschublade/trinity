extends Spatial
class_name Item

export(String) var item_id

var list_item
var item_details
var body
var data

func _ready():
	var item_db = get_node('/root/Global').item_db


func create_body():
	var body_res = load('res://assets/item/' + data['type'] + data['fname'] + 'body.tscn')
	body = body_res.instance()
