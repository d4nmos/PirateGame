extends Node3D

@onready var cell_area = $Cell_Area
@onready var start_marker = preload("res://scenes/test/simple_start_marker.tscn")
@onready var finish_marker = preload("res://scenes/test/simple_finish_marker.tscn")
@onready var path_market = preload("res://scenes/test/path_marker.tscn")

var col
var row
var count
var is_passability
var previous

var _grid_generator
var _delta

func _ready():
	count = 0
	is_passability = true
	_grid_generator = get_parent()

func _physics_process(delta):
	if cell_area.has_overlapping_bodies():
		self.global_transform.origin.y += 0.1
		count += 0.1 
		if count > 0.3:
			_grid_generator.grid_matrix[row][col] = null
			queue_free()

func set_as_path():
	var path = path_market.instantiate()
	add_child(path)
	path.global_transform.origin.y += 1
