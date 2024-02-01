extends PanelContainer

const SLOT = preload("res://inventory/scenes/slot.tscn")

@onready var item_grid = $MarginContainer/ItemGrid

func set_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_update.connect(populate_item_grid)
	populate_item_grid(inventory_data)
	
func clear_inventory_data(inventory_data: InventoryData):
	inventory_data.inventory_update.disconnect(populate_item_grid)
	
func populate_item_grid(inventory_data: InventoryData):
	for child in item_grid.get_children():
		child.queue_free()
	
	for one_slot_data in inventory_data.slot_data:
		var slot = SLOT.instantiate()
		item_grid.add_child(slot)
		
		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
		
		if one_slot_data:
			slot.set_slot_data(one_slot_data)
