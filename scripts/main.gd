extends Node3D

@onready var player = $player
@onready var inventory_interface = $UI/InventoryInterface

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.toggle_inventory.connect(toggle_iventory_interface)
	inventory_interface.set_player_inventory_data(player.inventory_data)

func toggle_iventory_interface():
	inventory_interface.visible = not inventory_interface.visible
	
	if inventory_interface.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		player.sens_horizontal = 0
		player.sens_vertical = 0
		player.attack_is_ready = false
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		player.sens_horizontal = 0.5
		player.sens_vertical = 0.5
		player.attack_is_ready = true
	
