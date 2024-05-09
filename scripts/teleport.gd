extends MeshInstance3D

var start_level: PackedScene

func _ready():
	start_level = preload("res://scenes/location1.tscn")
