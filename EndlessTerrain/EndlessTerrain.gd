class_name EndlessTerrain
extends Node3D

@export var chunkSize = 100
@export var terrain_height = 20
@export var view_distance = 500
@export var viewer :CharacterBody3D
@export var chunk_mesh_scene = preload("res://EndlessTerrain/TerrainChunk.tscn")
@export var render_debug := false
var viewer_position = Vector2()
var terrain_chunks = {}
var chunksvisible = 0

# For mix and generate position of chunks
var min_value = -150.0
var max_value = 150.0
var range = 0.5
var random_float = randf() * (max_value - min_value) + min_value + randf() * 2 * range - range


var last_visible_chunks = []
@export var noise:FastNoiseLite

func _ready():
	#set the total chunks to be visible
	chunksvisible = roundi(view_distance/chunkSize)
	if render_debug:
		set_wireframe()
	updateVisibleChunk()
	
	
func set_wireframe():
	RenderingServer.set_debug_generate_wireframes(true)
	get_viewport().debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
	
func _process(delta):
	viewer_position.x = viewer.global_position.x
	viewer_position.y = viewer.global_position.z
	updateVisibleChunk()

func updateVisibleChunk1():
	#hide chunks that were are out of view
	#get grid position
	var currentX = roundi(viewer_position.x/chunkSize)
	var currentY = roundi(viewer_position.y/chunkSize)
	#get all the chunks within visiblity range
	for yOffset in range(-chunksvisible,chunksvisible):
		for xOffset in range(-chunksvisible,chunksvisible):
			#create a new chunk coordinate 
			var view_chunk_coord = Vector2(currentX-xOffset,currentY-yOffset)
			#check if chunk was already created
			if terrain_chunks.has(view_chunk_coord):
				var ref = weakref(terrain_chunks[view_chunk_coord])
				#if chunk exist update the chunk passing viewer_position and view_distance
				terrain_chunks[view_chunk_coord].update_chunk(viewer_position,view_distance)
				if terrain_chunks[view_chunk_coord].update_lod(viewer_position):
					terrain_chunks[view_chunk_coord].generate_terrain(noise,view_chunk_coord,chunkSize,true)
			else:
				#print(view_chunk_coord)
				#if chunk doesnt exist, create chunk
				var chunk :TerrainChunk = chunk_mesh_scene.instantiate()
				add_child(chunk)
				#set chunk parameters
				chunk.Terrain_Max_Height = terrain_height
				#set chunk world position
				var pos = view_chunk_coord*chunkSize
				var world_position = Vector3(pos.x,0,pos.y)
				chunk.global_position = world_position
				chunk.generate_terrain(noise,view_chunk_coord,chunkSize,false)
				terrain_chunks[view_chunk_coord] = chunk
#check if we should remove chunk from scene
	for chunk in get_children():
		if chunk.should_remove(viewer_position,view_distance):
			chunk.queue_free()
			if terrain_chunks.has(chunk.grid_coord):
				terrain_chunks.erase(chunk.grid_coord)
			
		
func updateVisibleChunk():
	var currentX = roundi(viewer_position.x + random_float / chunkSize)
	var currentY = roundi(viewer_position.y + random_float / chunkSize) 
	var previous_chunk_position = Vector2(currentX, currentY)	
	
	for yOffset in range(-chunksvisible, chunksvisible):
		for xOffset in range(-chunksvisible, chunksvisible):
			#var view_chunk_coord = generateRandomChunkPosition(previous_chunk_position)  
			var view_chunk_coord = previous_chunk_position + Vector2(xOffset, yOffset) 
			
			if terrain_chunks.has(view_chunk_coord):
				var ref = weakref(terrain_chunks[view_chunk_coord])
				if terrain_chunks[view_chunk_coord].update_lod(viewer_position):
					terrain_chunks[view_chunk_coord].generate_terrain(noise, view_chunk_coord, chunkSize, true)
			else:
				var chunk :TerrainChunk = chunk_mesh_scene.instantiate()
				add_child(chunk)
				
				# Инвертирование значений вершин
				#var vertices = chunk.surface_get_arrays(0)[Arrays.MESH_ARRAY_VERTEX]
				#for i in range(vertices.size()):
				#	vertices[i] = -vertices[i]
					
				#mesh_instance.mesh = chunk
				#add_child(mesh_instance)
				
				chunk.Terrain_Max_Height = terrain_height
				var pos = view_chunk_coord * chunkSize
				var world_position = Vector3(pos.x, 0, pos.y)
				chunk.global_position = world_position
				chunk.generate_terrain(noise, view_chunk_coord, chunkSize, false)
				
				terrain_chunks[view_chunk_coord] = chunk
				previous_chunk_position = view_chunk_coord


func get_active_threads():
	return 0
