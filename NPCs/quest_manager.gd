extends Node2D
 
var quest : Quest:
	set(value):
		quest = value
 
		if value.objective == "Fetch":
			%Label.text = "-> " + value.description
 
func next_quest():
	DialogueManager.current_speaker.dialogue = quest.next_questline
	%Label.text = ""
