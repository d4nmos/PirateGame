extends Node3D

var path_matrix
var start = Vector2(0, 0)
var finish = Vector2(0, 0)
var matrix_size

func find_path():
	var reachable = [start]
	var explored = []
	
	while !reachable.is_empty():
		var cell = choose_cell(reachable)
		
		if cell == finish:
			show_path(build_path(finish))
			
		
		reachable.erase(cell)
		explored.append(cell)
		
		var new_reachable = get_adjacent_nodes(cell, explored)
		for adjacent in new_reachable:
			if adjacent not in reachable:
				get_cell_node_from_path_matrix(adjacent).previous = cell
				reachable.append(adjacent)
		
func choose_cell(reachable):
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
		path.append(to_node)
		var next_cell = get_cell_node_from_path_matrix(to_node)
		to_node = next_cell.previous
	
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
	
	return adjacent

func show_path(path):
	for cell in path:
		get_cell_node_from_path_matrix(cell).set_as_path()
