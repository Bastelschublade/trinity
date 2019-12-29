extends Node

signal start_journey(data)

signal grow_plants()

signal creature_killed(creature)

signal item_equiped(item)

signal item_unequiped(item)

signal item_collected(item, amount)

signal item_removed(item, amount)

signal gold_added(amount)

signal grace_added(amount)

signal location_entered(location)

signal region_entered(region)

signal note_created(note)

signal quest_started(quest)

signal quest_completed(quest)

signal quest_finished(quest)

signal quest_resetted(quest)

signal player_died()

func _ready():
	pass
