extends Node

@onready var DEFAULT_SETTINGS : DefaultSettingsResource = preload("res://systems/resourses/DefaultSettings.tres")

var window_mode_index : int = 0
var resolution_index : int = 0

var loaded_data : Dictionary = {}

func _ready():
	handle_signals()
	create_storage_dictionary()

func create_storage_dictionary() -> Dictionary:
	var settings_container_dict : Dictionary = {
		"window_mode_index" : window_mode_index,
		"resolution_index" : resolution_index,
		#"left" : InputMap.action_get_events("left"),
		#"right" : InputMap.action_get_events("right"),
		#"backward" : InputMap.action_get_events("backward"),
		#"forward" : InputMap.action_get_events("forward"),
		#"inventory" : InputMap.action_get_events("inventory"),
		#"interact" : InputMap.action_get_events("interact")
	}
	
	#print(settings_container_dict)
	return settings_container_dict

func get_window_mode_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_WINDOW_MODE_INDEX
	return window_mode_index

func get_resolution_index() -> int:
	if loaded_data == {}:
		return DEFAULT_SETTINGS.DEFAULT_RESOLUTION_INDEX
	return resolution_index


func on_window_mode_selected(index : int) -> void:
	window_mode_index = index

func on_resolution_selected(index : int) -> void:
	resolution_index = index

func on_settings_data_loaded(data : Dictionary) -> void:
	loaded_data = data
	#print(loaded_data)
	on_window_mode_selected(loaded_data.window_mode_index)
	on_resolution_selected(loaded_data.resolution_index)

	
func handle_signals() -> void:
	SettingsSignalBus.on_window_mode_selected.connect(on_window_mode_selected)
	SettingsSignalBus.on_resolution_selected.connect(on_resolution_selected)
	SettingsSignalBus.load_settings_data.connect(on_settings_data_loaded)

