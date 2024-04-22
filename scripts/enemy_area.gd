extends Node3D

@onready var grid_generator = $Grid_generator
@onready var skteleton_minion = preload("res://scenes/enemies/skeleton_minion.tscn")
@onready var path_finder = $path_finder

var path_matrix

func _ready():
	grid_generator.create_matrix()
	path_matrix = grid_generator.create_grid()
	path_finder.path_matrix = path_matrix
	path_finder.matrix_size = grid_generator.matrix_size
	spawn_enemy(skteleton_minion)
	

func spawn_enemy(enemy_tscn):
	var enemy = enemy_tscn.instantiate()
	add_child(enemy)
	var pos = get_random_pos()
	enemy.global_transform.origin.x = pos.x
	enemy.global_transform.origin.z = pos.z

func get_random_pos():
	var row = randi_range(0, grid_generator.matrix_size - 1)
	var col = randi_range(0, grid_generator.matrix_size - 1)
	
	return path_matrix[row][col].global_transform.origin

