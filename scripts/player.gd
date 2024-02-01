extends CharacterBody3D

@onready var camera_mount = $camera_mount
@onready var animation_player = $visuals/character/AnimationPlayer
@onready var animation_tree = $visuals/character/AnimationTree
@onready var visuals = $visuals
@onready var interface = $"../UI/OtherInterface"

@export var sens_horizontal = 0.5
@export var sens_vertical = 0.5
@export var damage = 1.0
@export var inventory_data: InventoryData
@export var interaction_manager: InteractionManager
@export var speed = 3.0
@export var jump_velocity = 4.5

var attack_is_ready: bool = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Signals
signal toggle_inventory()

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
		animation_tree.set("parameters/in_air/transition_request", true)
#		print(velocity.y)
		if velocity.y <= -20:
			animation_tree.set("parameters/air movements/transition_request", "fall forward")
	else:
		animation_tree.set("parameters/in_air/transition_request", false)

	# Handle Jump.
	if !Globals.control_ship:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
#			animation_tree.set("parameters/air movements/transition_request", "jump")

	# Get the input direction and handle the movement/deceleration.
	var direction = Vector3.ZERO
	if !Globals.control_ship:
		var input_dir = Input.get_vector("left", "right", "forward", "backward")
		direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		animation_tree.set("parameters/movements/transition_request", "walk")
		visuals.look_at(position + direction)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		animation_tree.set("parameters/movements/transition_request", "idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()

func _process(delta):
	if !Globals.control_ship and is_on_floor():
		if Input.is_mouse_button_pressed(1) and attack_is_ready:
			$attack/attack_range.disabled = false
			$visuals/visual_attack_range.visible = true 
			animation_tree.set("parameters/movements/transition_request", "punch")
		else:
			$attack/attack_range.disabled = true
			$visuals/visual_attack_range.visible = false
#	else: 
#		if Input.is_action_just_pressed("interact"):
#			Globals.control_ship = false
	
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("next_interact_object"):
		interaction_manager.up_pointer()
	
	if Input.is_action_just_pressed("prev_interact_object"):
		interaction_manager.down_pointer()
	
	if Input.is_action_just_pressed("interact") and interaction_manager.current_object != null:
		interaction_manager.current_object.player_interact()
	
	

#Нанесение урона противнику		
func _on_attack_body_entered(body):
	if body.is_in_group("Enemies"):
		body.take_damage(damage)
	else:
		pass
		
#Добавление объекта в список взаимодействия, когда он входит в радиус взаимодействия		
func _on_interaction_area_body_entered(body):
	if body.is_in_group("Interactable"):
		interaction_manager.add_interactable_object(body)
	else:
		pass
		
#Удаление объекта из списока взаимодействия, когда он выходит из радиуса взаимодействия		
func _on_interaction_area_body_exited(body):
	if body in interaction_manager.interactable_objects:
		interaction_manager.remove_interactable_object(body)
	else:
		pass 

func _on_animation_tree_animation_finished(anim_name):
	if is_on_floor(): 
		animation_tree.set("parameters/movements/transition_request", "idle")
	else:
		animation_tree.set("parameters/air movements/transition_request", "fall")




