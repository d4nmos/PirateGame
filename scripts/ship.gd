extends AnimatableBody3D

@onready var visuals = $visuals

const ACCELIRATION = 1.02
const DECELERATION = 1.06
const SPEED_LIMIT = 5.0
const ROTATION_SPEED_LIMIT = 1.5

var speed = 0.0
var rotation_speed = 0.0

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector3.FORWARD
	if Globals.control_ship:
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
			#	(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		
		if Input.is_action_pressed("forward") and speed < SPEED_LIMIT: 
			if speed == 0:
				speed = 1.0
			else: 
				speed *= ACCELIRATION
		if Input.is_action_pressed("backward") and speed / DECELERATION >= 0: 
			if speed <= 1:
				speed = 0.0
			else:
				speed /= DECELERATION
				
#		if Input.is_action_pressed("left"):
#			rotate_object_local(Vector3(0, 1, 0), deg_to_rad(rotation_speed * delta))
#		elif Input.is_action_pressed("right"):
#			rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-rotation_speed * delta))

		if Input.is_action_pressed("left") and rotation_speed < ROTATION_SPEED_LIMIT: 
			if rotation_speed == 0:
				rotation_speed = 0.1
			elif rotation_speed > 0:
				rotation_speed *= ACCELIRATION
			else:
				if rotation_speed >= -0.1:
					rotation_speed = 0.0
				else:
					rotation_speed /= DECELERATION
		
		if Input.is_action_pressed("right") and rotation_speed > -ROTATION_SPEED_LIMIT: 
			if rotation_speed == 0:
				rotation_speed = -0.1
			elif rotation_speed < 0:
				rotation_speed *= ACCELIRATION
			else:
				if rotation_speed <= 0.1:
					rotation_speed = 0.0
				else:
					rotation_speed /= DECELERATION

	var rotation = rotation_speed * delta
	var translation = direction * speed * delta
	rotate_y(rotation)	
#	translate(translation)
	
		
#		var angle = -direction.x * rotation_speed * delta
#		var axis = Vector3.UP
#		rotate(axis, angle)



func _on_control_area_body_entered(body):
	if body.name == "player":
		# The body is a player
		Globals.control_ship = true
	else:
		# The body is not a player
		pass
