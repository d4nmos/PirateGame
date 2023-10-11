extends AnimatableBody3D

@onready var visuals = $visuals

const ACCELIRATION = 1.02
const DECELERATION = 1.06
const SPEED_LIMIT = 5.0

var speed = 0.0
var rotationSpeed = 10.0

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector3.FORWARD
	if Globals.controlShip:
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
			#	(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		
		if Input.is_action_pressed("forward"): 
			if speed == 0:
				speed = 1.0
			elif speed >= SPEED_LIMIT:
				pass
			else: 
				speed *= ACCELIRATION
		if Input.is_action_pressed("backward") and speed / DECELERATION >= 0: 
			if speed <= 1:
				speed = 0.0
			else:
				speed /= DECELERATION
				
#		if Input.is_action_pressed("left"):
#			rotate_object_local(Vector3(0, 1, 0), deg_to_rad(rotationSpeed * delta))
#		elif Input.is_action_pressed("right"):
#			rotate_object_local(Vector3(0, 1, 0), deg_to_rad(-rotationSpeed * delta))

#		if Input.is_action_pressed("right"):
#			direction.x += 1
#		if Input.is_action_pressed("left"):
#			direction.z -= 1
		
	var translation = direction * speed * delta
	translate(translation)
		
#		var angle = -direction.x * ROTATIONSPEED * delta
#		var axis = Vector3.UP
#		rotate(axis, angle)



func _on_control_area_body_entered(body):
	if body.name == "player":
		# The body is a player
		Globals.controlShip = true
	else:
		# The body is not a player
		pass
