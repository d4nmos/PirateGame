extends CharacterBody3D

@onready var interact_arrow_3d = $interact_arrow_3D
@onready var control_point = $Control_Point
@onready var rotate_point = $Rotate_Point

var _is_chosen = false

func chose_this_object():
	_is_chosen = true

func unchose_this_object():
	_is_chosen = false

func _process(delta):
	if _is_chosen and global.player.global_transform.origin.distance_to(control_point.global_transform.origin) < 2:
		interact_arrow_3d.visible = true
	else:
		interact_arrow_3d.visible = false

func player_interact():
	if global.player.global_transform.origin.distance_to(control_point.global_transform.origin) < 2:
		global.player.global_transform.origin = control_point.global_transform.origin
		global.player.look_at(rotate_point.global_transform.origin, Vector3.UP)
	else:
		pass
