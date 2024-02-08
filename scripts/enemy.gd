extends CharacterBody3D

var hp
var speed = 2
var accel = 1
var target_node

@export var max_hp_value = 5

@onready var navigation_agent_3d = $NavigationAgent3D

func _ready():
	hp = max_hp_value
	
	var parent = get_parent_node_3d()
	target_node = parent.get_node("target")
	if not target_node:
		print("TargetNode not found in the scene.")

func _physics_process(delta):
	var direction = Vector3()
	
	navigation_agent_3d.target_position = target_node.global_position
	
	direction = navigation_agent_3d.get_next_path_position() - global_position
	direction.normalized()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
	
func take_damage(damage):
	hp -= damage
	
	var health_bar_reducer = (damage * 100) / max_hp_value
	$health_bar_3D/SubViewport/healthBar2D.value -= health_bar_reducer
	
	if hp <= 0:
		queue_free()
