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


var _head_accuracy

func ready():
	_head_accuracy = get_accuracy(skeleton_3d ,'head', head_collision)
	set_state('idle', 'idle')
	
func process():
	update_colission_pos(skeleton_3d, 'head', head_collision, _head_accuracy)
	update_colission_pos(skeleton_3d, 'chest', torso_collision)
	update_colission_pos(skeleton_3d, 'foot.l', leg_left_collision)
	update_colission_pos(skeleton_3d, 'foot.r', leg_right_collision)

func _on_vision_timer_timeout():
	var overlaps = vision_area.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == 'player':
				var player_pos = overlap.global_transform.origin
				vision_raycast.look_at(player_pos, Vector3.UP)
				vision_raycast.force_raycast_update()
				
				if vision_raycast.is_colliding():
					var collider = vision_raycast.get_collider()
					
					if collider.name == 'player':
						vision_raycast.debug_shape_custom_color = Color(174, 0, 0)
					else:
						vision_raycast.debug_shape_custom_color = Color(0, 255, 0)

func idle():
#	if _timer > 3:
#		set_state('move_idle', 'move_idle')
#	else:
#		pass
	pass

func move_idle():
	move_ai()
	if _timer > 3:
		set_state('idle', 'idle')
	else:
		pass
	


