extends Spatial
class_name vehicle



func _ready():
	var events = get_node('/root/Events')
	events.connect("start_journey", self, "start_journey")
	print('vehicle spawned')
	

func start_journey(journeyid):
	# TODO if jouney_id == self.journey_id: (or (follow)path name in children..)
	print('reise gestartet')

