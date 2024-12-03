extends TextureRect

@onready var dialogue = $Dialogue

func set_dialogue(pos: Vector2, text: String, is_flip_h = true):
	flip_h = is_flip_h
	dialogue.text = text
	dialogue.size = Vector2(dialogue.get_content_width(), dialogue.get_content_height())
	size = Vector2(dialogue.size.x+50, dialogue.size.y+50)
	position = Vector2(pos.x, pos.y - size.y)
	dialogue.position = Vector2(25,15)
