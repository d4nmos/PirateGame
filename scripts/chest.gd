extends StaticBody3D

func _ready():
	pass

func chose_this_object():
	$interact_arrow_3D.visible = true

func unchose_this_object():
	$interact_arrow_3D.visible = false
