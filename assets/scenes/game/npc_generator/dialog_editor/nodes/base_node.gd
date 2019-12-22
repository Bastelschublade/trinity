extends GraphNode
class_name MyGraphNode

func _ready():
	pass


func _on_close_request():
	self.queue_free()