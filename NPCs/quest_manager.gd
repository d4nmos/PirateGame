extends Node2D

var quest : Quest:
	set(value):
		quest = value
		if value.objective == "Fetch":
			%Quest_name.text = "-> " + value.description

func next_quest():
	DialogueManager.current_speaker.dialogue = quest.next_questline
	%Quest_name.text = ""

func change_quest_color():
	%Quest_name.label_settings.font_color = Color(0, 167, 0)
