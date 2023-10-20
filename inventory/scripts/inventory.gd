extends PanelContainer

const SLOT = preload("res://inventory/scenes/slot.tscn")

@onready var item_grid = $MarginContainer/ItemGrid

func _ready():
	var inv_data = preload("res://inventory/test_inventory.tres")
	populate_item_grid(inv_data.slot_data)

func populate_item_grid(slot_data: Array[SlotData]):
	for child in item_grid.get_children():
		child.queue_free()
	
	for one_slot_data in slot_data:
		var slot = SLOT.instantiate()
		item_grid.add_child(slot)
		
		if one_slot_data:
			slot.set_slot_data(one_slot_data)
