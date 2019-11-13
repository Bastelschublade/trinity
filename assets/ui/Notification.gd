extends Label

func _ready():
	pass


func _on_Timer_timeout():
	self.queue_free()
