extends AnimatableBody3D

@onready var visuals = $visuals

const SPEED = 1.0
const ROTATIONSPEED = 10.0

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Globals.controlShip:
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		var direction = Vector3.FORWARD	#	(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

#		if Input.is_action_pressed("right"):
#			direction.x += 1
#		if Input.is_action_pressed("left"):
#			direction.z -= 1
		
		var translation = direction * SPEED * delta
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
