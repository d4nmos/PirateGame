extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var animation_player = $visuals/character/AnimationPlayer
@onready var visuals = $visuals

const SPEED = 3.0
const JUMP_VELOCITY = 4.5

@export var sens_horizontal = 0.5
@export var sens_vertical = 0.5
@export var damage = 1.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
#		if !Globals.control_ship:
		var hRotation = deg_to_rad(-event.relative.x * sens_horizontal)
		rotate_y(hRotation)
		visuals.rotate_y(-hRotation)
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if !Globals.control_ship:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			if animation_player.current_animation != "jumping":
				animation_player.play("jumping")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector3.ZERO
	if !Globals.control_ship:
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if animation_player.current_animation != "happy walk":
			animation_player.play("happy walk")
		
		visuals.look_at(position + direction)

		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		if animation_player.current_animation != "Happy Idle":
			animation_player.play("Happy Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()

func _process(delta):
	if !Globals.control_ship:
		if Input.is_mouse_button_pressed(1):
			$attack/attack_range.disabled = false
			$visuals/visual_attack_range.visible = true 
			
			if animation_player.current_animation != "Jab Punch":
				animation_player.play("Jab Punch")
		else:
			$attack/attack_range.disabled = true
			$visuals/visual_attack_range.visible = false
	else: 
		if Input.is_action_pressed("action"):
			Globals.control_ship = false
		
func _on_attack_body_entered(body):
	if body.is_in_group("Enemies"):
		body.take_damage(damage)
	else:
		pass
