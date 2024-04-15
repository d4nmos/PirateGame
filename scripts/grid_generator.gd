extends Node3D

@onready var cell_scn = preload("res://scenes/cell.tscn")
@onready var empty_box = $Empty_box

@export var matrix_size = 3

var _cell_x_scale
var _cell_z_scale
var _grid_matrix
var _stack: Array = []

func _ready():
	_grid_matrix = create_matrix(matrix_size)
	create_grid()


func create_grid():
	var start_pos = empty_box.global_transform.origin
	var middle_matrix_pos = get_middle_matrix_pos()
	get_cell_scale()
	
	start_pos.x -= _cell_x_scale * middle_matrix_pos
	start_pos.z -= _cell_z_scale * middle_matrix_pos
	
	create_neighbors(start_pos)

func create_neighbors(start_pos):
	var pos = start_pos
	
	for i in range(matrix_size):
		for j in range(matrix_size):
			_grid_matrix[i][j] = 1
			var new_cell = cell_scn.instantiate()
			new_cell.row = i
			new_cell.col = j
			add_child(new_cell)
			
			new_cell.global_transform.origin = pos
			pos.x += _cell_x_scale
			
		pos.x = start_pos.x
		pos.z += _cell_z_scale

func create_matrix(rows_and_cols):
	var matrix = []
	for i in range(rows_and_cols):
		var row = []
		for j in range(rows_and_cols):
			row.append(0)
		matrix.append(row)
	return matrix

func get_middle_matrix_pos():
	return matrix_size / 2

func get_cell_scale():
	var cellInstance = cell_scn.instantiate()
	add_child(cellInstance)
	_cell_x_scale = cellInstance.scale.x
	_cell_z_scale = cellInstance.scale.z
	cellInstance.queue_free()
