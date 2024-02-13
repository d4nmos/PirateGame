extends CharacterBodyAI

@export var max_hp_value = 5

var hp = null

func ready():
	hp = max_hp_value
	set_state('idle')
	
func take_damage(damage):
	hp -= damage
	
	var health_bar_reducer = (damage * 100) / max_hp_value
	$health_bar_3D/SubViewport/healthBar2D.value -= health_bar_reducer
	
	if hp <= 0:
		queue_free()

#States
func idle(): pass

func move(): pass
