extends Node3D
@export var slot_data: SlotData
@onready var sprite_3d: Sprite3D = $Sprite3D
 
func _ready():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 0, 0)
	sprite_3d.texture = slot_data.item_data.texture

func _physics_process(delta):	
	sprite_3d.rotate_y(delta)


func add_highlight() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 7, 0.5)
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)

func remove_highlight() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)

# Open the chest if unopened
func _on_interactable_interacted(_interactor: Interactor) -> void:
	slot_data.item_data.find = true
	
	if _interactor.controller.inventory_data.pick_up_slot_data(slot_data):
		remove_highlight()
		queue_free()

# Add white outline
func _on_interactable_focused(_interactor: Interactor) -> void:
	add_highlight()

# Remove white outline
func _on_interactable_unfocused(_interactor: Interactor) -> void:
	remove_highlight()
