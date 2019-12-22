extends Textual
class_name Condition

export(bool) var default_true = true  # if nothing given to check
export(bool) var force_default = false  # always return default (for testings)

func _ready():
	pass


func check():
	return default_true