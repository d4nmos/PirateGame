extends CharacterBody3D

@export var hp = 5.0

func take_damage(damage):
	hp -= damage
	print(hp)	
	
	if hp <= 0:
		queue_free()
