extends Node2D

@export var next_button : PackedScene
@export var quest_button : PackedScene

var dialogue : Dialogue:
	set(value):
		dialogue = value
		
		if current_speaker:
			current_speaker.dialogue = value
		
		%UI_dialog/PanelContainer/VBoxContainer/HBoxContainer/Icon.texture = value.texture
		%UI_dialog/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name.text = value.name
		%UI_dialog/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/Dialogue.text = value.dialogue
		
		reset_options()
		
		if value.quest:
			add_quest(value.quest)
		
		add_buttons(value.options)
		
		await get_tree().create_timer(0.5).timeout
		%UI_dialog/PanelContainer/VBoxContainer/Options.show()

var current_speaker = null


#func _ready():
#	dialogue = load("res://NPCs/Pirate/Dialogues/0.tres")
	

func reset_options():
	for child in %UI_dialog/PanelContainer/VBoxContainer/Options.get_children():
		child.queue_free()
	%UI_dialog/PanelContainer/VBoxContainer/Options.hide()

func add_buttons(options):
	for option in options:
		var button = next_button.instantiate()
		button.dialogue = option
		%UI_dialog/PanelContainer/VBoxContainer/Options.add_child(button)
		
func hide_dialogue():
	%UI_dialog.hide()
	
func show_dialogue():
	%UI_dialog.show()

func add_quest(quest):
	if QuestManager.quest == quest:
		return
	var button = quest_button.instantiate()
	button.quest = quest
	%UI_dialog/PanelContainer/VBoxContainer/Options.add_child(button)
		

