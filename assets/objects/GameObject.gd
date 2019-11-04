extends RigidBody

class_name GameObject

export(String) var go_tooltip
export(bool) var go_collectable
export(bool) var go_attackable

func _ready():
	print('Game Object created:')
	print(self.name)
