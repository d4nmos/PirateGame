extends CharacterBodyAI

#OneReady
@onready var skeleton_3d = $Rig/Skeleton3D
@onready var head_collision = $Head_Collision
@onready var torso_collision = $Torso_Collision
@onready var leg_left_collision = $LegLeft_Collision
@onready var leg_right_collision = $LegRight_Collision
@onready var vision_collision = $Vision_Area/Vision_Collision
@onready var vision_area = $Vision_Area
@onready var vision_raycast = $Vision_Raycast
@onready var vision_timer = $VisionTimer
@onready var path_find_timer = $Path_Find_Timer
@onready var floor_middle_raycast = $Floor_Middle_Raycast
@onready var floor_bot_raycast = $Floor_Bot_Raycast
@onready var floor_top_raycast = $Floor_Top_Raycast
@onready var return_in_area_timer = $Return_In_Area_Timer

#Private variables
var _head_accuracy
var _target_node = global.player
var _enemy_area
var _is_can_see = true
var _return_cell_position = Vector2(1, 1)

#Variables
var current_cell
var path
var target_cell
var finish_cell
var current_player_cell
var current_cell_as_object
var cell_before_run_to_player

#Methods
func ready():
	_enemy_area = get_parent()
	_head_accuracy = get_accuracy(skeleton_3d ,'head', head_collision)
	set_state('idle', 'idle')
	
func process():
	update_colission_pos(skeleton_3d, 'head', head_collision, _head_accuracy)
	update_colission_pos(skeleton_3d, 'chest', torso_collision)
#	update_colission_pos(skeleton_3d, 'foot.l', leg_left_collision)
#	update_colission_pos(skeleton_3d, 'foot.r', leg_right_collision)

func update_vision_raycast():
		var target_position
		target_position = _target_node.global_transform.origin
		target_position.y = vision_raycast.global_transform.origin.y
		vision_raycast.look_at(target_position, Vector3.UP)
		vision_raycast.force_raycast_update()

func set_path_to_object():
	path = _enemy_area.find_path(current_cell, finish_cell)
	target_cell = path.pop_back()

#Signals
func _on_vision_area_body_entered(body):
	if body.is_in_group("Player"):
		vision_raycast.enabled = true
		vision_timer.start()

func _on_vision_area_body_exited(body):
	if body.is_in_group("Player"):
#		vision_raycast.enabled = false
		vision_timer.stop()

func _on_vision_timer_timeout():
	update_vision_raycast()
	if vision_raycast.get_collider().is_in_group('Player'):
		vision_timer.stop()
		vision_collision.disabled = true
		set_state('taunt', 'taunt')
		
func _on_return_in_area_timer_timeout():
	set_state('return_area_sad', 'stop_agro')

#States
func idle():
	if _timer > 3:
		finish_cell = _enemy_area.get_random_cell()
		_return_cell_position = current_cell
		path = _enemy_area.find_path(current_cell, finish_cell)
		target_cell = path.pop_back()
		set_state('patrolling', 'move_idle')

func patrolling():
	if path.is_empty():
		finish_cell = _enemy_area.get_random_cell()
		_return_cell_position = current_cell
		path = _enemy_area.find_path(current_cell, finish_cell)
		target_cell = path.pop_back()
		
	if distance_to_node(target_cell) < 1.0:
		target_cell = path.pop_back()
	else:
		rotate_to_node(target_cell)
		move_angle()

func taunt():
	if !_animator.is_playing():
		vision_raycast.enabled = false
		cell_before_run_to_player = current_cell
		set_state('run_to_player', 'run_to_player')

func run_to_player():
	rotate_to_node(global.player)
	move_angle(2)
	
	if floor_bot_raycast.is_colliding() or floor_middle_raycast.is_colliding() or floor_top_raycast.is_colliding():
			path = _enemy_area.find_path(current_cell, _enemy_area.player_current_cell)
			target_cell = path.pop_back()
			vision_raycast.enabled = true
			set_state('avoid_wall', 'run_to_player')
			
func avoid_wall():
	update_vision_raycast()
	if path.is_empty():
		if vision_raycast.get_collider().is_in_group('Player'):
			vision_raycast.enabled = false
			set_state('run_to_player', 'run_to_player')
		else:
			vision_collision.disabled = false
			vision_raycast.enabled = false
			set_state('return_to_prev_pos_sad', 'stop_agro')
	else:
		if distance_to_node(target_cell) < 1.0:
			target_cell = path.pop_back()
		else:
			rotate_to_node(target_cell)
			move_angle(2)

func return_area_sad():
	if !_animator.is_playing():
		current_cell_as_object = _enemy_area.get_cell_node_from_path_matrix(current_cell)
		set_state('return_in_area', 'move_idle')
		
func return_in_area():
	if distance_to_node(current_cell_as_object) < 0.1:
		vision_collision.disabled = false
		floor_middle_raycast.enabled = true 
		floor_bot_raycast.enabled = true
		floor_top_raycast.enabled = true
		set_state('idle', 'idle')
	else:
		rotate_to_node(current_cell_as_object)
		move_angle()

func return_to_prev_pos_sad():
	if !_animator.is_playing():
		path = _enemy_area.find_path(current_cell, cell_before_run_to_player)
		target_cell = path.pop_back()
		set_state('return_to_prev_pos', 'move_idle')

func return_to_prev_pos():
	if path.is_empty():
		set_state('idle', 'idle')
	else:
		if distance_to_node(target_cell) < 1:
			target_cell = path.pop_back()
		else:
			rotate_to_node(target_cell)
			move_angle()

func atack():
	pass

func afk():
	pass




