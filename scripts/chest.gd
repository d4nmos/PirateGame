extends StaticBody3D

@export var inventory_data: InventoryData

signal toggle_inventory(external_inventory_owner)

func chose_this_object():
	$interact_arrow_3D.visible = true

func unchose_this_object():
	$interact_arrow_3D.visible = false

func player_interact():
	toggle_inventory.emit(self)

