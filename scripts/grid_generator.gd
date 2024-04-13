extends Node3D

@onready var cell = preload("res://scenes/cell.tscn")
@onready var empty_box = $Empty_box

func _ready():
	var cellInstance = cell.instantiate()
	add_child(cellInstance)
	cellInstance.global_transform.origin = empty_box.global_transform.origin

