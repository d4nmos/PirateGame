extends Resource
class_name InventoryData

signal inventory_update(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_data: Array[SlotData]


func grab_slot_data(index: int) -> SlotData:
	var grabbed_slot_data = slot_data[index]
	
	if grabbed_slot_data:
		slot_data[index] = null
		inventory_update.emit(self)
		return grabbed_slot_data
	else:
		return null
	
func drop_slot_data(grabbed_slot_data: SlotData,index: int) -> SlotData:
	var one_slot_data = slot_data[index]
	var return_slot_data: SlotData
	
	if one_slot_data and one_slot_data.can_fully_merge_with(grabbed_slot_data):
		one_slot_data.fully_merge_with(grabbed_slot_data)
	else:
		slot_data[index] = grabbed_slot_data
		return_slot_data = one_slot_data
	
	inventory_update.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: SlotData,index: int) -> SlotData:
	var one_slot_data = slot_data[index]
	
	if not one_slot_data:
		slot_data[index] = grabbed_slot_data.create_single_slot_data()
	elif one_slot_data.can_merge_with(grabbed_slot_data):
		one_slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
	
	inventory_update.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func pick_up_slot_data(one_slot_data: SlotData):
	for index in slot_data.size():
		if slot_data[index] and slot_data[index].can_fully_merge_with(one_slot_data):
			slot_data[index].fully_merge_with(one_slot_data)
			inventory_update.emit(self)
			return true
	
	for index in slot_data.size():
		if not slot_data[index]:
			slot_data[index] = one_slot_data
			inventory_update.emit(self)
			return true
	return false

func on_slot_clicked(index: int, button: int):
	inventory_interact.emit(self, index, button)

