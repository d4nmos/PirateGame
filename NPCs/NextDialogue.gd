extends Button
 
var dialogue : Dialogue:
	set(value):
		dialogue = value
		text = dialogue.path_option
 
func _on_pressed():
	if dialogue.options.size() == 0:
		DialogueManager.hide_dialogue()
		DialogueManager.dialogue.ends = true
		return
 
	DialogueManager.dialogue = dialogue
 
