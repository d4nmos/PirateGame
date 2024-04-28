extends Node3D

@onready var cell_area = $Cell_Area
@onready var start_marker = preload("res://scenes/test/simple_start_marker.tscn")
@onready var finish_marker = preload("res://scenes/test/simple_finish_marker.tscn")
@onready var path_marker = preload("res://scenes/test/path_marker.tscn")
@onready var detect_area = $Detect_Area

var col
var row
var count
var is_passability = true
var previous

var enemy_area
var _delta

func _ready():
	count = 0
	enemy_area = get_parent()

func _physics_process(delta):
	if cell_area.has_overlapping_bodies() and is_passability == true:
		self.global_transform.origin.y += 0.1
		count += 0.1 
		if count > 0.3:
			is_passability = false
#			detect_area.disabled = true

func set_as_path():
	var path = path_marker.instantiate()
	add_child(path)
	path.global_transform.origin.y += 1

func set_as_start():
	var start = start_marker.instantiate()
	add_child(start)
	start.global_transform.origin.y += 1

func set_as_finish():
	var finish = finish_marker.instantiate()
	add_child(finish)
	finish.global_transform.origin.y += 1




func _on_detect_area_body_entered(body):
	if body.is_in_group('Enemies'):
		body.current_cell = Vector2(row, col)
