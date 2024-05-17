extends Button
 
var quest : Quest:
	set(value):
		quest = value
		text = value.title + " [КВЕСТ]"
 
func _on_pressed():
	QuestManager.quest = quest
	queue_free()
