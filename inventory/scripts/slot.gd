extends PanelContainer

@onready var texture_rect = $MarginContainer/TextureRect
@onready var quantity_label = $QuantityLabel


func set_slot_data(one_slot_data: SlotData):
	var item_data = one_slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
	
	if one_slot_data.quantity > 1:
		quantity_label.text = "x%s" % one_slot_data.quantity
		quantity_label.show()
