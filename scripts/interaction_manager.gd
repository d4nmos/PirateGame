extends Resource
class_name InteractionManager

var interactable_objects = []
var interaction_pointer = -1
var current_object = null

func add_interactable_object(object):
	interactable_objects.append(object)
	interaction_pointer += 1
	change_current_object(interaction_pointer)

func remove_interactable_object(object):
	interactable_objects.erase(object)
	
	if interactable_objects.is_empty():
		interaction_pointer = -1
		current_object.unchose_this_object()
		current_object = null
	else:
		interaction_pointer = 0
		change_current_object(interaction_pointer) 
	
func up_pointer():
	if not interactable_objects.is_empty() and interaction_pointer < interactable_objects.size() - 1:
		interaction_pointer += 1
		change_current_object(interaction_pointer)
	
func down_pointer():
	if not interactable_objects.is_empty() and interaction_pointer > 0:
		interaction_pointer -= 1
		change_current_object(interaction_pointer)

func change_current_object(pointer):
	if current_object != null:
		current_object.unchose_this_object()
		
	current_object = interactable_objects[pointer]
	current_object.chose_this_object()
