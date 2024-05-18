extends Node3D

@export var inventory_data: InventoryData
signal toggle_inventory(external_inventory_owner)

func _ready():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 0, 0)
	
func add_highlight() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 7, 0.5)
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)

func remove_highlight() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)

# Open the chest if unopened
func _on_interactable_interacted(_interactor: Interactor) -> void:
	toggle_inventory.emit(self)
	remove_highlight()
		
	print("get chest")		
	#queue_free()

func _on_interactable_focused(_interactor: Interactor) -> void:
	add_highlight()

func _on_interactable_unfocused(_interactor: Interactor) -> void:
	remove_highlight()


func _on_toggle_inventory(external_inventory_owner):
	pass # Replace with function body.
