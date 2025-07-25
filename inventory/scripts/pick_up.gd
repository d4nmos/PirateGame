extends RigidBody3D

@export var slot_data: SlotData

@onready var sprite_3d = $Sprite3D

func _ready():
	sprite_3d.texture = slot_data.item_data.texture

func _physics_process(delta):	
	sprite_3d.rotate_y(delta)

func _on_area_3d_area_entered(area):
	var parent = area.get_parent()
	
	if parent.inventory_data.pick_up_slot_data(slot_data):
		queue_free()
