extends CharacterBody3D

@export var max_hp_value = 5
var hp

func _ready():
	hp = max_hp_value
	
func take_damage(damage):
	hp -= damage
	
	var health_bar_reducer = (damage * 100) / max_hp_value
	$health_bar_3D/SubViewport/healthBar2D.value -= health_bar_reducer
	
	if hp <= 0:
		queue_free()
