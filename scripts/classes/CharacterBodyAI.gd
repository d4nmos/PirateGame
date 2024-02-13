extends CharacterBody3D
class_name CharacterBodyAI

@export var detector_node : NodePath
@export var speed = 1
@export var speed_turn = 0.5

var _timer = 0
var _delta = 0
var _detector = null
var _prev_state = ''
var _prev_sub_state = ''
var _detected = null

var state = ''
var sub_state = ''
var parent = null
var player = null

func _ready():
	if detector_node:
		_detector = get_node(detector_node)
	parent = get_parent_node_3d()
	player = parent.get_node('player')
	ready() 

func _physics_process(delta):
	_delta = delta
	_timer += delta
	if _detector and _detector.is_colliding():
		_detected = _detector.get_collider()
	#	print(state)
	call(state)
	process()

func set_state(s):
	state = s
	
func move_ai():
	if _detected:
		set_state('tmp_rotate')

#func move_angle():
#	velocity = Vector3(0,-5, -speed).rotated(Vector3.UP, rotation.y)
#	move_and_slide()
#	if _detected:
#		set_state('tmp_rotate')

func rotate_to_node(n):
	var a = global_transform
	var origin = n.global_transform.origin
	origin.y = a.origin.y
	var b = a.looking_at(origin, Vector3.UP)
	global_transform = global_transform.interpolate_with(b, speed_turn * _delta)
	print(b)

#States
func idle():
	rotate_to_node(player)

func move():
	move_ai()

func tmp_rotate(): pass

#Methods
func ready(): pass

func process(): pass

