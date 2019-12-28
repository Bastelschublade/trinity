extends NodeCondition


func _ready():
	self.condition_name = 'Hat Items'

func export():
	var data = {}
	data['item_alias'] = get_node('ItemAlias/LineEdit').text
	data['item_amount'] = get_node('ItemAmount/Value').value
	return data