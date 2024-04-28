extends CharacterBody3D
class_name CharacterBodyAI

@export var detector_node : NodePath
@export var animator_node : AnimationPlayer
@export_multiline var sub_state_anim
@export var speed = 1
@export var speed_turn = 1
@export var random_timer_rotate_min = 0.5
@export var random_timer_rotete_max = 3.0

var _timer = 0
var _delta = 0
var _detector = null
var _prev_state = ''
var _prev_sub_state = ''
var _detected = null
var _animations = {}
var _animator = null
var _dir = 0
var _random_time_rotate = 0

var state = ''
var sub_state = ''
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if detector_node:
		_detector = get_node(detector_node)
	if animator_node:
		_animator = animator_node
	if sub_state_anim:
		var pairs = sub_state_anim.split('\n')
		for pair in pairs:
			var anim = pair.split(':')
			_animations[anim[0]] = anim[1]
			
	ready() 

func _physics_process(delta):
	_delta = delta
	_timer += delta
	if _detector:
		if _detector.is_colliding():
			_detected = _detector.get_collider()
		else:
			_detected = null
		
	if not is_on_floor():
		velocity.y -= gravity * delta
		move_and_slide()

	call(state)
	process()

func set_state(s, sub = ''):
	print(s)
	_timer = 0
	if state != s:
		_prev_state = state
		state = s
	if sub:
		set_sub_state(sub)

func set_sub_state(sub):
	if sub_state != sub:
		_prev_sub_state = sub_state
		if _animator:
			_animator.play(_animations[sub], 0.2)
			
	sub_state = sub
	
func move_ai():
	move_angle()
	if _detected:
		set_state('tmp_rotate')
	
func move_angle(add_speed = 0):
	velocity = Vector3(0,velocity.y, -(speed + add_speed)).rotated(Vector3.UP, rotation.y)
	move_and_slide()

func rotate_to_node(n, add_speed = 0):
	var a = global_transform
	var origin = n.global_transform.origin
	origin.y = a.origin.y
	var b = a.looking_at(origin, Vector3.UP)
	global_transform = global_transform.interpolate_with(b, (add_speed + speed_turn) * _delta)
		
func distance_to_node(n):
	return global_transform.origin.distance_to(n.global_transform.origin)

func random_range_and_rotate_time():
	_dir = randi_range(-1, 1)
	_random_time_rotate = randf_range(random_timer_rotate_min, random_timer_rotete_max)

#States
func idle(): pass

func move(): pass

func tmp_rotate():
	rotate_y(speed_turn * _delta)
	if !_detected and _timer > 1:
		set_state(_prev_state)
		
#Methods
func ready(): pass

func process(): pass

func update_colission_pos(skeleton_3d, bone_name, collision_object, accuracy = 0):
	var bone = skeleton_3d.find_bone(bone_name)
	var bone_transform = skeleton_3d.get_bone_global_pose(bone)
	var bone_position = skeleton_3d.to_global(bone_transform.origin)
	
	bone_position.y += accuracy
	collision_object.global_transform.origin = bone_position

func get_accuracy(skeleton_3d, bone_name, collision_object):
	var bone = skeleton_3d.find_bone(bone_name)
	var bone_transform = skeleton_3d.get_bone_global_pose(bone)
	var bone_position = skeleton_3d.to_global(bone_transform.origin)
	var accuracy = collision_object.global_transform.origin.y - bone_position.y
	return accuracy

