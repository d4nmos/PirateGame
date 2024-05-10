extends Node3D

@export var dialogue: Dialogue

@export var highlight_material: StandardMaterial3D

#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var chest_meshinstance: MeshInstance3D = $sword_shield_gold
@onready var chest_material: StandardMaterial3D = chest_meshinstance.mesh.surface_get_material(0)

var is_open: bool = false

func open() -> void:
	is_open = true
	var questSign = $Quest_sign
	var questSign2 = $Quest_sign2
	if questSign:
		questSign.visible = false
	if questSign2:
		questSign2.visible = false
	#animation_player.play("Open")

func add_highlight() -> void:
	#chest_meshinstance.set_surface_override_material(0, chest_material.duplicate())
	#chest_meshinstance.get_surface_override_material(0).next_pass = highlight_material
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 7, 0.5)
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)

func remove_highlight() -> void:
	pass

# Open the chest if unopened
func _on_interactable_interacted(_interactor: Interactor) -> void:
	DialogueManager.dialogue = dialogue
	#DialogueManager.current_speaker = self
	DialogueManager.show_dialogue()
	if not is_open:
		#remove_highlight()
		#$Interactable.queue_free()
		open()


# Add white outline
func _on_interactable_focused(_interactor: Interactor) -> void:
	if not is_open:
		add_highlight()

# Remove white outline
func _on_interactable_unfocused(_interactor: Interactor) -> void:
	remove_highlight()
