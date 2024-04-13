extends Node3D

var positive_x_neighbor
var negative_x_nrighbor
var positive_z_neighbor
var negative_z_neighbor

@onready var cell_area = $Cell_Area
@onready var ray_cast_3d = $RayCast3D

func _ready():
	pass

func _physics_process(delta):
	if cell_area.has_overlapping_bodies():
		self.global_transform.origin.y += 0.1
	if ray_cast_3d.is_colliding():
		var collision_point = ray_cast_3d.get_collision_point()
		var distance = ray_cast_3d.global_transform.origin.distance_to(collision_point)
		print("Расстояние до коллизии:", distance)
		
