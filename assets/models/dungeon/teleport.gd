extends Node3D

@onready var start_level = preload("res://scenes/location1.tscn")

func _ready():
	start_level = preload("res://scenes/lighthouse.tscn")

func _on_Area_entered(area: Area) -> void:
	if area.is_in_group("player"):
		get_tree().change_scene_to_packed(start_level)
