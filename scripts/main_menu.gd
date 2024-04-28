class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var end_button = $MarginContainer/HBoxContainer/VBoxContainer/End_Button as Button

@onready var start_level = preload("res://scenes/lighthouse.tscn")

func _ready():
	start_button.button_down.connect(on_start_pressed)
	end_button.button_down.connect(on_end_pressed)


func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_end_pressed() -> void:
	get_tree().quit()
	
