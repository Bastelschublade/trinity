extends Condition
class_name ConditionList

export(String, 'All', 'Any') var must_hold

func _ready():
	pass

func check():
	var all = (must_hold == 'All')
	for c in get_children():
		if not c is Condition:
			continue
		if c.check() != all:
			return !all
	return all
