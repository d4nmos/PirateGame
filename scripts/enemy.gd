extends CharacterBodyAI

@export var max_hp_value = 5

var hp = null

func ready():
	hp = max_hp_value
	set_state('idle')

func process(): pass
	
func take_damage(damage):
	hp -= damage
	
	var health_bar_reducer = (damage * 100) / max_hp_value
	$health_bar_3D/SubViewport/healthBar2D.value -= health_bar_reducer
	
	if hp <= 0:
		queue_free()

#States
func idle():
	if _timer > 5: 
		_timer = 0
		find_player()

func move():
	if distance_to_node(global.player) > 6:
		rotate_to_node(global.player)
		move_angle()
	else:
		set_state('attack_move')

func attack_move():
	if distance_to_node(global.player) < 7:
		rotate_to_node(global.player,2)
		move_angle(2)
	else:
		set_state('move_idle')
		
func rotate_idle():
	if _timer < _random_time_rotate:
		rotate_y(speed_turn * _dir * _delta)
	else:
		_timer = 0
		set_state('move_idle')

func move_idle():
	move_ai()
	if _timer > 5: 
		_timer = 0
		find_player()

func find_player():
	if distance_to_node(global.player) < 10:
		set_state('move')
		return
		
	if state == 'move_idle':
		set_state('idle')
	elif state == 'idle':
		random_range_and_rotate_time()
		set_state('rotate_idle')

