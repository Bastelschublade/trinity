extends NodeCondition


func _ready():
	self.condition_name = 'Hat Gunst'


func export():
	var data = {}
	data['grace'] = get_node('Grace/Value').value
	return data