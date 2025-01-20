extends CanvasLayer

@onready var texture_rect = $TextureRect
@onready var dialogue = $TextureRect/Dialogue

var padding_x = 150.0
var padding_y = 125.0
var max_width = 250

func set_dialogue(pos: Vector2, text: String):
	dialogue.text = text
	dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dialogue.custom_minimum_size.x = max_width
	await get_tree().process_frame
	dialogue.custom_minimum_size.y = dialogue.get_content_height()

	texture_rect.size = Vector2(dialogue.get_content_width()+padding_x, (dialogue.get_content_height()+padding_y)*1.2)
	
	var viewport_size = get_viewport().get_visible_rect().size
	var canva_pos = get_viewport().get_canvas_transform() * pos
	
	if canva_pos.x > viewport_size.x / 2:
		texture_rect.flip_h = false
		texture_rect.position = Vector2(canva_pos.x - texture_rect.size.x + 50, canva_pos.y - texture_rect.size.y)
	else:
		texture_rect.flip_h = true
		texture_rect.position = Vector2(canva_pos.x, canva_pos.y - texture_rect.size.y)
		
	dialogue.position = Vector2(padding_x / 2, padding_y / 2)
	
	show()
