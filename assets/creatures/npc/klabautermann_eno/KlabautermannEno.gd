extends NPC

func _ready():
	pass


func trigger(data):
	if data == 'show_leg':
		$Body/Root/BoneAttachment/Spatial/Cylinder.set_visible(true)