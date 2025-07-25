extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var texture_rect: TextureRect = $MarginContainer/TextureRect
@onready var quantity_label: Label = $QuantityLabel

func set_slot_data(one_slot_data: SlotData):
	var item_data = one_slot_data.item_data
	texture_rect.texture = item_data.texture
	tooltip_text = "%s\n%s" % [item_data.name, item_data.description]

	if one_slot_data.quantity > 1:
		quantity_label.text = "x%s" % one_slot_data.quantity
		quantity_label.show()
	else:
		quantity_label.hide()

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)

