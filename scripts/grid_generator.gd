extends Node3D

@onready var cell_scn = preload("res://scenes/cell.tscn")
@onready var empty_box = $Empty_box

@export var matrix_size = 3

var _cell_x_scale
var _cell_z_scale
var _start_cell
var _finish_cell

var grid_matrix

func _ready():
	grid_matrix = create_matrix(matrix_size)
	create_grid()
	set_random_start()
	set_random_finish()
	
	find_path()

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
			var new_cell = cell_scn.instantiate()
			new_cell.row = i
			new_cell.col = j
			add_child(new_cell)
			grid_matrix[i][j] = new_cell
			
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
	
func set_random_start():
	var row = randi_range(0, matrix_size - 1)
	var col = randi_range(0, matrix_size - 1)
	if grid_matrix[row][col].is_passability:
		grid_matrix[row][col].set_as_start()
		_start_cell = Vector2(row, col)
		return
	else:
		set_random_start()

func set_random_finish():
	var row = randi_range(0, matrix_size - 1)
	var col = randi_range(0, matrix_size - 1)
	if grid_matrix[row][col].is_passability:
		grid_matrix[row][col].set_as_finish()
		_finish_cell = Vector2(row, col)
		return
	else:
		set_random_finish()

func find_path():
	var reachable = [_start_cell]
	var explored = []
	
	while !reachable.is_empty():
		var cell = choose_cell(reachable)
		
		if cell == _finish_cell:
			show_path(build_path(_finish_cell))
			
		
		reachable.erase(cell)
		explored.append(cell)
		
		var new_reachable = get_adjacent_nodes(cell, explored)
		for adjacent in new_reachable:
			if adjacent not in reachable:
				get_cell_node_from_grid_matrix(adjacent).previous = cell
				reachable.append(adjacent)
		
func choose_cell(reachable):
	var min_distance = 1.79769e+308
	var chosen_cell
	var finish = get_cell_node_from_grid_matrix(_finish_cell)
	var current_cell
	
	for cell in reachable:
		current_cell = get_cell_node_from_grid_matrix(cell)
		var current_distance = get_distance_to(current_cell, finish)
		
		if current_distance < min_distance:
			min_distance = current_distance
			chosen_cell = cell
			
	return chosen_cell

func get_cell_node_from_grid_matrix(cell_row_col):
	return grid_matrix[cell_row_col.x][cell_row_col.y]

func get_distance_to(first_cell, second_cell):
	var distance = first_cell.global_transform.origin.distance_to(second_cell.global_transform.origin)
	return distance

func build_path(finish):
	var path = []
	var to_node = finish
	while to_node != null:
		path.append(to_node)
		var next_cell = get_cell_node_from_grid_matrix(to_node)
		to_node = next_cell.previous
	
	return path

func get_adjacent_nodes(node, explored):
	var row = node.x
	var col = node.y
	var adjacent = []
	
	if col - 1 >= 0:
		if grid_matrix[row][col - 1].is_passability and Vector2(row, col - 1) not in explored:
			adjacent.append(Vector2(row, col - 1))
	
	if col + 1 < matrix_size:
		if grid_matrix[row][col + 1].is_passability and Vector2(row, col + 1) not in explored:
			adjacent.append(Vector2(row, col + 1))
	
	if row - 1 >= 0:
		if grid_matrix[row - 1][col].is_passability and Vector2(row - 1, col) not in explored:
			adjacent.append(Vector2(row - 1, col))
			
	if row + 1 < matrix_size:
		if grid_matrix[row + 1][col].is_passability and Vector2(row + 1, col) not in explored:
			adjacent.append(Vector2(row + 1, col))
	
	return adjacent

func show_path(path):
	for cell in path:
		get_cell_node_from_grid_matrix(cell).set_as_path()
	
	

