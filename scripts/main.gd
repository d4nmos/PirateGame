extends Node3D

const PickUp = preload("res://inventory/items/pick_up/pick_up.tscn")

@onready var player = $player
@onready var inventory_interface = $UI/InventoryInterface
@onready var speed = player.speed
@onready var sens_horizontal = player.sens_horizontal
@onready var sens_vertical = player.sens_vertical
@onready var jump_velocity = player.jump_velocity

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SimpleGrass.set_interactive(true)
	#player.toggle_inventory.connect(toggle_iventory_interface)
	#inventory_interface.set_player_inventory_data(player.inventory_data)
	
	for node in get_tree().get_nodes_in_group("ExternalInventory"):
		node.toggle_inventory.connect(toggle_iventory_interface)

func toggle_iventory_interface(external_inventory_owner = null):
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.sens_horizontal = 0
		player.sens_vertical = 0
		player.attack_is_ready = false
		player.speed = 0
		player.jump_velocity = 0
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.sens_horizontal = sens_horizontal
		player.sens_vertical = sens_vertical
		player.attack_is_ready = true
		player.speed = speed
		player.jump_velocity = jump_velocity
	
	if external_inventory_owner:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()
	


func _on_inventory_interface_drop_slot_data(slot_data):
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = player.get_drop_position()
	add_child(pick_up)
