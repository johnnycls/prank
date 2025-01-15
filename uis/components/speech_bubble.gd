extends CanvasLayer

@onready var texture_rect = $TextureRect
@onready var dialogue = $TextureRect/Dialogue

func set_dialogue(pos: Vector2, text: String, is_flip_h = true):
	show()
	texture_rect.flip_h = is_flip_h
	dialogue.text = text
	var max_width = 300
	var content_width = min(dialogue.get_content_width(), max_width)
	dialogue.custom_minimum_size.x = content_width
	dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue.size.y = dialogue.get_content_height()
	texture_rect.size = Vector2(content_width + 100, dialogue.size.y + 100)
	var canva_pos = get_viewport().get_canvas_transform() * pos
	texture_rect.position = Vector2(canva_pos.x, canva_pos.y - texture_rect.size.y)
	dialogue.position = Vector2(40, 30)
