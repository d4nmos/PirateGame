class_name MainMenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var end_button = $MarginContainer/HBoxContainer/VBoxContainer/End_Button as Button
@onready var options_button = $MarginContainer/HBoxContainer/VBoxContainer/Options_Button as Button
@onready var options_menu = $Options_Menu as OptionsMenu
@onready var margin_container = $MarginContainer as MarginContainer

@onready var start_level = preload("res://scenes/location1.tscn")

func _ready():
	_handle_connecting_signals()

func on_start_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)

func on_options_pressed() -> void:
	margin_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true
	
func on_end_pressed() -> void:
	get_tree().quit()
	
func on_exit_options_menu() -> void:
	margin_container.visible = true
	options_menu.visible = false
	
func _handle_connecting_signals():
	start_button.button_down.connect(on_start_pressed)
	options_button.button_down.connect(on_options_pressed)
	end_button.button_down.connect(on_end_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)
