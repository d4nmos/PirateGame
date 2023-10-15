extends AnimatableBody3D

@onready var visuals = $visuals

const ACCELIRATION = 1.02
const DECELERATION = 1.06

const BASE_SPEED = 1.0
const SPEED_LIMIT = 5.0

const BASE_ROTATION_SPEED = 0.1
const ROTATION_SPEED_LIMIT = 1.5

var speed = 0.0
var rotation_speed = 0.0

func accelerate(speed, base_speed = BASE_SPEED, speed_limit = SPEED_LIMIT, acceleration = ACCELIRATION):
	if speed < speed_limit: 
		if speed == 0:
			speed = base_speed
		else: 
			speed *= acceleration
	return speed
	
func decelerate(speed, base_speed = BASE_SPEED, speed_limit = SPEED_LIMIT, deceleration = DECELERATION):
	if speed / deceleration >= 0: 
		if speed <= base_speed:
			speed = 0
		else:
			speed /= deceleration
	return speed


func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector3.FORWARD
	if Globals.control_ship:
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
			#	(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if Input.is_action_pressed("forward"):
			speed = accelerate(speed)
		if Input.is_action_pressed("backward"):
			speed = decelerate(speed)
			
		if Input.is_action_pressed("left"): 
			if rotation_speed >= 0:
				rotation_speed = accelerate(abs(rotation_speed), BASE_ROTATION_SPEED, ROTATION_SPEED_LIMIT)
			else:
				rotation_speed = -decelerate(abs(rotation_speed), BASE_ROTATION_SPEED, ROTATION_SPEED_LIMIT)
		if Input.is_action_pressed("right"): 
			if rotation_speed <= 0:
				rotation_speed = -accelerate(abs(rotation_speed), BASE_ROTATION_SPEED, ROTATION_SPEED_LIMIT)
			else:
				rotation_speed = decelerate(abs(rotation_speed), BASE_ROTATION_SPEED, ROTATION_SPEED_LIMIT)
	
	direction = direction.rotated(Vector3(0,1,0), rotation_speed)
	var translation = direction * speed * delta
	translate(translation)
	
func _on_control_area_body_entered(body):
	if body.name == "player":
		# The body is a player
		Globals.control_ship = true
	else:
		# The body is not a player
		pass
