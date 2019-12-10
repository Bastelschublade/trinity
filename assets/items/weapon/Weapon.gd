extends Item
class_name Weapon

export(String, "mainhand", "offhand") var slot = "mainhand"
 
var speed = 1  # 1/seconds between attacks
var damage = 5
var noise = 2  # effective damage = rand(damage-noise, damage+noise)
var hit = 0.5
var parry = 1

func _ready():
	pass
