extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head_collision = $Head_Collision
@onready var skeleton_minion_head = $Rig/Skeleton3D/Skeleton_Minion_Head
@onready var animation_player = $AnimationPlayer
@onready var skeleton_3d = $Rig/Skeleton3D

var _head_bone

func _ready():
	animation_player.current_animation = "Death_B"
	_head_bone = skeleton_3d.find_bone("head")

func _process(delta):
	var head_transform = skeleton_3d.get_bone_global_pose(_head_bone)
	var head_position = skeleton_3d.to_global(head_transform.origin)
	head_position.y += 0.52
	
	head_collision.global_transform.origin = head_position
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		move_and_slide()
