extends Node3D

@onready var skteleton_minion = preload("res://scenes/enemies/skeleton_minion.tscn")
@onready var cell_scn = preload("res://scenes/cell.tscn")
@onready var empty_box = $empty_box
@onready var border_area = $Border_Area

@export var matrix_size = 21

var _cell_x_scale
var _cell_z_scale

var available_cells = []
var path_matrix = []
var player_current_cell = null

func _ready():
	create_matrix()
	create_grid()
	expansion_of_territory()
	spawn_enemy(skteleton_minion)

func expansion_of_territory():
	var new_size_x = matrix_size * _cell_x_scale
	var new_size_z = matrix_size * _cell_z_scale
	
	border_area.scale.x = new_size_x
	border_area.scale.z = new_size_z

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
			path_matrix[i][j] = new_cell
			
			new_cell.global_transform.origin = pos
#			if i == 0 or j == 0 or i == matrix_size - 1 or j == matrix_size - 1:
#				new_cell.is_passability = false
#			else:
			available_cells.append(new_cell)
			pos.x += _cell_x_scale
			
		pos.x = start_pos.x
		pos.z += _cell_z_scale

func create_matrix():
	for i in range(matrix_size):
		var row = []
		for j in range(matrix_size):
			row.append(0)
		path_matrix.append(row)

func get_middle_matrix_pos():
	return matrix_size / 2

func get_cell_scale():
	var cellInstance = cell_scn.instantiate()
	add_child(cellInstance)
	_cell_x_scale = cellInstance.scale.x
	_cell_z_scale = cellInstance.scale.z
	cellInstance.queue_free()
	
func spawn_enemy(enemy_tscn):
	var enemy = enemy_tscn.instantiate()
	add_child(enemy)
	var pos = path_matrix[18][18].global_transform.origin
	enemy.global_transform.origin.x = pos.x
	enemy.global_transform.origin.z = pos.z

func get_random_cell():
	if available_cells.size() > 0:
		var random_cell = available_cells[randi_range(0, available_cells.size() - 1)]
		var row = random_cell.row
		var col = random_cell.col
		return Vector2(row, col)
	else:
		return Vector2(1, 1)

func find_path(start, finish):
	var reachable = [start]
	var explored = []
	get_cell_node_from_path_matrix(start).set_as_start()
	get_cell_node_from_path_matrix(finish).set_as_finish()
	
	while !reachable.is_empty():
		var cell = choose_cell(reachable, finish)
		
		if cell == finish:
			return build_path(finish)
			
		
		reachable.erase(cell)
		explored.append(cell)
		
		var new_reachable = get_adjacent_nodes(cell, explored)
		for adjacent in new_reachable:
			if adjacent not in reachable:
				get_cell_node_from_path_matrix(adjacent).previous = cell
				reachable.append(adjacent)
		
func choose_cell(reachable, finish):
	var min_distance = 1.79769e+308
	var chosen_cell
	var finish_node = get_cell_node_from_path_matrix(finish)
	var current_cell
	
	for cell in reachable:
		current_cell = get_cell_node_from_path_matrix(cell)
		var current_distance = get_distance_to(current_cell, finish_node)
		
		if current_distance < min_distance:
			min_distance = current_distance
			chosen_cell = cell
			
	return chosen_cell

func get_cell_node_from_path_matrix(cell_row_col):
	return path_matrix[cell_row_col.x][cell_row_col.y]

func get_distance_to(first_cell, second_cell):
	var distance = first_cell.global_transform.origin.distance_to(second_cell.global_transform.origin)
	return distance

func build_path(finish_cell):
	var path = []
	var to_node = finish_cell
	
	while to_node != null:
		var next_node
		to_node = get_cell_node_from_path_matrix(to_node)
		path.append(to_node)
		to_node.set_as_path()
		next_node = to_node.previous
		to_node.previous = null
		to_node = next_node

	return path

func get_adjacent_nodes(node, explored):
	var row = node.x
	var col = node.y
	var adjacent = []
	
	if col - 1 >= 0:
		if path_matrix[row][col - 1].is_passability and Vector2(row, col - 1) not in explored:
			adjacent.append(Vector2(row, col - 1))
	
	if col + 1 < matrix_size:
		if path_matrix[row][col + 1].is_passability and Vector2(row, col + 1) not in explored:
			adjacent.append(Vector2(row, col + 1))
	
	if row - 1 >= 0:
		if path_matrix[row - 1][col].is_passability and Vector2(row - 1, col) not in explored:
			adjacent.append(Vector2(row - 1, col))
			
	if row + 1 < matrix_size:
		if path_matrix[row + 1][col].is_passability and Vector2(row + 1, col) not in explored:
			adjacent.append(Vector2(row + 1, col))
	
	if row - 1 >= 0 and col - 1 >= 0:
		if path_matrix[row - 1][col - 1].is_passability and Vector2(row - 1, col - 1) not in explored:
			adjacent.append(Vector2(row - 1, col - 1))

	if row + 1 < matrix_size and col + 1 < matrix_size:
		if path_matrix[row + 1][col + 1].is_passability and Vector2(row + 1, col + 1) not in explored:
			adjacent.append(Vector2(row + 1, col + 1))

	if row - 1 >= 0 and col + 1 < matrix_size:
		if path_matrix[row - 1][col + 1].is_passability and Vector2(row - 1, col + 1) not in explored:
			adjacent.append(Vector2(row - 1, col + 1))

	if row + 1 < matrix_size and col - 1 >= 0:
		if path_matrix[row + 1][col - 1].is_passability and Vector2(row + 1, col - 1) not in explored:
			adjacent.append(Vector2(row + 1, col - 1))

	return adjacent

func _on_border_area_body_exited(body):
	body.return_in_area_timer.start()
	body.floor_middle_raycast.enabled = false 
	body.floor_bot_raycast.enabled = false
	body.floor_top_raycast.enabled = false
