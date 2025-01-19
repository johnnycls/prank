extends CanvasLayer

@onready var texture_rect = $TextureRect
@onready var dialogue = $TextureRect/Dialogue

var padding_x = 150.0
var padding_y = 150.0

func transform_vector_with_aspect_ratio(original: Vector2, aspect_ratio: float) -> Vector2:
	var x2 = sqrt(original.x * original.y * aspect_ratio)
	var y2 = x2 / aspect_ratio
	return Vector2(x2, y2)

func set_dialogue(pos: Vector2, text: String):
	var original_texture = texture_rect.texture
	var texture_aspect = float(original_texture.get_width()) / float(original_texture.get_height())
	
	dialogue.text = text
	dialogue.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	await get_tree().process_frame
	dialogue.custom_minimum_size = transform_vector_with_aspect_ratio(
		Vector2(dialogue.get_content_width(), dialogue.get_content_height()),
		texture_aspect)
		
	texture_rect.size = Vector2(dialogue.get_content_width()+padding_x, dialogue.get_content_height()+padding_y+50)
	
	var viewport_size = get_viewport().get_visible_rect().size
	var canva_pos = get_viewport().get_canvas_transform() * pos
	
	if canva_pos.x > viewport_size.x / 2:
		texture_rect.flip_h = true
		texture_rect.position = Vector2(canva_pos.x, canva_pos.y - texture_rect.size.y)
	else:
		texture_rect.flip_h = false
		texture_rect.position = Vector2(canva_pos.x - texture_rect.size.x, canva_pos.y - texture_rect.size.y)
		
	dialogue.position = Vector2(padding_x / 2, padding_y / 2)
	
	show()
