extends TextureRect

@onready var dialogue = $Dialogue

func set_dialogue(pos: Vector2, text: String, is_flip_h = true):
	show()
	flip_h = is_flip_h
	dialogue.text = text
	var max_width = 300
	var content_width = min(dialogue.get_content_width(), max_width)
	dialogue.custom_minimum_size.x = content_width
	dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue.size.y = dialogue.get_content_height()
	size = Vector2(content_width + 100, dialogue.size.y + 100)
	position = Vector2(pos.x, pos.y - size.y)
	dialogue.position = Vector2(40, 30)
