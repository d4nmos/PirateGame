extends Node3D

@onready var cell = preload("res://scenes/cell.tscn")
@onready var empty_box = $Empty_box

@export var matrix_size = 5

var _cell_x_scale
var _cell_z_scale
var _grid_matrix
var _empty_cell

func _ready():
	_grid_matrix = create_matrix(matrix_size)
	create_grid()


func create_grid():
	var start_row = get_middle_matrix_pos()
	var start_col = get_middle_matrix_pos()
	var start_cell_pos = empty_box.global_transform.origin
	get_cell_scale()
#	create_neighbors(start_row, start_col, start_cell_pos)
	test_create_neighbors(start_row, start_col, start_cell_pos)
	
func create_neighbors(row, col, cell_pos):
	_grid_matrix[row][col] = 1
	var cellInstance = cell.instantiate()
	add_child(cellInstance)
	cellInstance.global_transform.origin = cell_pos
	
	if row - 1 >= 0:
		if _grid_matrix[row - 1][col] == 0:
			create_neighbors(row - 1, col, get_forward_pos(cell_pos))
	
	if col + 1 < matrix_size:
		if _grid_matrix[row][col + 1] == 0:
			create_neighbors(row, col + 1, get_right_pos(cell_pos))
	
	if row + 1 < matrix_size:
		if _grid_matrix[row + 1][col] == 0:
			create_neighbors(row + 1, col, get_backward_pos(cell_pos))
	
	if col - 1 >= 0:
		if _grid_matrix[row][col - 1] == 0:
			create_neighbors(row, col - 1, get_left_pos(cell_pos))

func test_create_neighbors(start_row, start_col, start_cell_pos):
	var stack = []
	_empty_cell = cell.instantiate()
	_empty_cell.row = start_row
	_empty_cell.col = start_col
	_empty_cell.pos = start_cell_pos
	stack.append(_empty_cell)
	
	while stack.size() > 0:
		var current = stack.pop_back()
		var row = current.row
		var col = current.col
		var cell_pos = current.pos
		
		_grid_matrix[row][col] = 1
		var cellInstance = cell.instantiate()
		add_child(cellInstance)
		cellInstance.global_transform.origin = cell_pos
		
		if row - 1 >= 0 and _grid_matrix[row - 1][col] == 0:
			_empty_cell.row = row - 1
			_empty_cell.col = col
			_empty_cell.pos = get_forward_pos(cell_pos)
			stack.append(_empty_cell)
		
		if col + 1 < matrix_size and _grid_matrix[row][col + 1] == 0:
			_empty_cell.row = row
			_empty_cell.col = col + 1
			_empty_cell.pos = get_right_pos(cell_pos)
			stack.append(_empty_cell)
		
		if row + 1 < matrix_size and _grid_matrix[row + 1][col] == 0:
			_empty_cell.row = row + 1
			_empty_cell.col = col
			_empty_cell.pos = get_backward_pos(cell_pos)
			stack.append(_empty_cell)
		
		if col - 1 >= 0 and _grid_matrix[row][col - 1] == 0:
			_empty_cell.row = row
			_empty_cell.col = col - 1
			_empty_cell.pos = get_left_pos(cell_pos)
			stack.append(_empty_cell)


func get_forward_pos(original_pos):
	var new_pos = original_pos
	new_pos.z -= _cell_z_scale
	return new_pos

func get_backward_pos(original_pos):
	var new_pos = original_pos
	new_pos.z += _cell_z_scale
	return new_pos

func get_right_pos(original_pos):
	var new_pos = original_pos
	new_pos.x += _cell_x_scale
	return new_pos

func get_left_pos(original_pos):
	var new_pos = original_pos
	new_pos.x -= _cell_x_scale
	return new_pos

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
	var cellInstance = cell.instantiate()
	add_child(cellInstance)
	_cell_x_scale = cellInstance.scale.x
	_cell_z_scale = cellInstance.scale.z
	cellInstance.queue_free()
