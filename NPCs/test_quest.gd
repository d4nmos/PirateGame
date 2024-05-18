extends Node3D

@export var dialogue: Dialogue
const BottlePickUp = preload("res://NPCs/bottle_pick_up.tscn")

@export var highlight_material: StandardMaterial3D

@onready var chest_meshinstance: MeshInstance3D = $sword_shield_gold
@onready var chest_material: StandardMaterial3D = chest_meshinstance.mesh.surface_get_material(0)

var is_clear: bool = false

func _ready():
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 0, 0)

func add_sign() -> void:
	var questSign = $Quest_sign
	var questSign2 = $Quest_sign2
	if questSign:
		questSign.visible = true
	if questSign2:
		questSign2.visible = true
		
func remove_sign() -> void:
	var questSign = $Quest_sign
	var questSign2 = $Quest_sign2
	if questSign:
		questSign.visible = false
	if questSign2:
		questSign2.visible = false


func add_highlight() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 7, 0.5)
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)

func remove_highlight() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($OmniLight3D, 'light_energy', 0, 2)

func _on_interactable_interacted(_interactor: Interactor) -> void:
	var pick_up = BottlePickUp.instantiate()
	if QuestManager.quest != null:
		if QuestManager.quest.number == "1" and pick_up.slot_data.item_data.find:
			QuestManager.next_quest()
			pick_up.slot_data.item_data.find = false
	if pick_up.slot_data.item_data.find:
		QuestManager.change_quest_color()		
	DialogueManager.dialogue = dialogue
	DialogueManager.current_speaker = self
	DialogueManager.show_dialogue()
	if DialogueManager.dialogue.ends:
		remove_sign()

func _on_interactable_focused(_interactor: Interactor) -> void:
	add_highlight()
	DialogueManager.dialogue = dialogue
	DialogueManager.current_speaker = self
	if not DialogueManager.dialogue.ends:
		add_sign()
		

func _on_interactable_unfocused(_interactor: Interactor) -> void:
	remove_highlight()
	remove_sign()
