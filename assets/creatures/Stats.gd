extends Node
class_name Stats


export(float) var base_health = 20
export(float) var base_hit    = 0.5
export(float) var base_block  = 0.5
export(float) var base_shoot  = 0.5
export(float) var base_power  = 20
export(float) var base_armor  = 0
export(float) var base_speed  = 1


var base = {
	'health': base_health,
	'hit'   : base_hit,
	'block' : base_block,
	'shoot' : base_shoot,
	'power' : base_power,
	'armor' : base_armor,
	'speed' : base_speed,
}


var current


func _ready():
	current = base


func reset_stats():
	print('reset stats to: ', base)
	current = base


func apply_stats(add_stats):
	if not add_stats or len(add_stats) < 1:
		print('Nothing to apply')
		return false
	for s in add_stats.current:
		if not s in current:
			print('stat not found: ', s)
			continue
		current[s] += add_stats.current[s]


func update():
	reset_stats()
	var par = get_parent()
	if par is Player:
		# update gear
		for g in par.gear.values():
			if not 'item' in g:
				continue
			apply_stats(g['item'].stats)
		# update buffs
		for b in par.buffs:
			apply_stats(b.stats)