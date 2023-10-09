extends AnimatableBody3D

@onready var visuals = $visuals

const SPEED = 1.0

const ROTATIONSPEED = 1.0

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = Vector3.FORWARD	#	(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_pressed("right"):
		direction = direction.rotated(Vector3.UP, -delta * ROTATIONSPEED)
	if Input.is_action_pressed("left"):
		direction = direction.rotated(Vector3.UP, delta * ROTATIONSPEED)
	
	var translation = direction * SPEED * delta	
	translate(translation)

#	var velocity = direction * SPEED
#	var result = move_and_collide(velocity * delta)
#	if result != null:
#		direction = result.normal.slide(direction)
