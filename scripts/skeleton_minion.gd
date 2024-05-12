extends CharacterBodyAI

@onready var head_collision = $Head_Collision
@onready var skeleton_minion_head = $Rig/Skeleton3D/Skeleton_Minion_Head
@onready var animation_player = $AnimationPlayer
@onready var skeleton_3d = $Rig/Skeleton3D
@onready var torso_collision = $Torso_Collision
@onready var leg_left_collision = $LegLeft_Collision
@onready var leg_right_collision = $LegRight_Collision
@onready var vision_area = $Vision_Area
@onready var vision_raycast = $Vision_Raycast
@onready var vision_timer = $VisionTimer
@onready var agro_timer = $Agro_Timer
@onready var agro_vision_timer = $Agro_Vision_Timer
@onready var vision_collision = $Vision_Area/Vision_Collision
@onready var path_find_timer = $Path_Find_Timer

var _head_accuracy
var _target_position
var _target_node
var _enemy_area

var current_cell
var path
var target_cell
var finish_cell
var current_player_cell

func ready():
	_enemy_area = get_parent()
	_head_accuracy = get_accuracy(skeleton_3d ,'head', head_collision)
	set_state('idle', 'idle')
	
func process():
#	print(current_cell)
	update_colission_pos(skeleton_3d, 'head', head_collision, _head_accuracy)
	update_colission_pos(skeleton_3d, 'chest', torso_collision)
#	update_colission_pos(skeleton_3d, 'foot.l', leg_left_collision)
#	update_colission_pos(skeleton_3d, 'foot.r', leg_right_collision)

func update_vision_raycast():
		_target_position = _target_node.global_transform.origin
		_target_position.y = vision_raycast.global_transform.origin.y
		vision_raycast.look_at(_target_position, Vector3.UP)
		vision_raycast.force_raycast_update()

func _on_vision_timer_timeout():
	vision_raycast.enabled = true
	update_vision_raycast()
	if vision_raycast.get_collider().is_in_group('Player'):
		vision_timer.stop()
		set_state('taunt', 'taunt')
		vision_raycast.debug_shape_custom_color = Color(133, 0, 0)
	else:
		vision_raycast.debug_shape_custom_color = Color(0, 255, 0)

func _on_agro_vision_timer_timeout():
	vision_raycast.enabled = true
	vision_collision.disabled = true
	update_vision_raycast()
	if vision_raycast.is_colliding() and vision_raycast.get_collider().is_in_group('Player'):
		vision_raycast.debug_shape_custom_color = Color(133, 0, 100)
	else:
		agro_vision_timer.stop()
		agro_timer.start()
		vision_raycast.debug_shape_custom_color = Color(0, 0, 255)

func _on_agro_timer_timeout():
	set_state('stop_agro','stop_agro')
	vision_raycast.enabled = false
	vision_collision.disabled = false

func _on_path_find_timer_timeout():
	if finish_cell != _enemy_area.player_current_cell:
		finish_cell = _enemy_area.player_current_cell
		path = _enemy_area.find_path(current_cell, finish_cell)
		target_cell = path.pop_back()
		target_cell = path.pop_back()
		
func _on_vision_area_body_entered(body):
	if body.is_in_group("Player"):
		_target_node = body
		vision_timer.start()
	else:
		pass
		
func _on_vision_area_body_exited(body):
	if body.is_in_group("Player"):
		vision_timer.stop()
		vision_raycast.enabled = false
	else:
		pass

func idle():
	if _timer > 3:
		finish_cell = Vector2(19, 19)
		path = _enemy_area.find_path(current_cell, finish_cell)
		target_cell = path.pop_back()
		set_state('patrolling', 'move_idle')
	else:
		pass

func rotation_idle():
	rotate_y(speed_turn * 1 * _delta)
	if _timer > 0.3:
		set_state('move_idle', 'move_idle')

func move_idle():
	move_ai()
	if _timer > 3:
		set_state('idle', 'idle')
	else:
		pass

func taunt():
	agro_vision_timer.start()
	if !_animator.is_playing():
		if _enemy_area.player_current_cell:
			finish_cell = _enemy_area.player_current_cell
			path = _enemy_area.find_path(current_cell, finish_cell)
			target_cell = path.pop_back()
			target_cell = path.pop_back()
	
			path_find_timer.start()
			set_state('run_to_player','run_to_player')
		else:
			set_state('taunt', 'taunt')
	else:
		pass

func run_to_player():
	if !path.is_empty():
		if distance_to_node(target_cell) < 1:
			target_cell = path.pop_back()
		else:
			rotate_to_node(target_cell, 2)
			move_angle(2)

func stop_agro():
	if !_animator.is_playing():
		set_state('idle', 'idle')
	else:
		pass

func patrolling():
	if path.is_empty():
		set_state('idle', 'idle')
		
	if distance_to_node(target_cell) < 1.0:
		target_cell = path.pop_back()
	else:
		rotate_to_node(target_cell)
		move_angle()

func afk():
	pass

