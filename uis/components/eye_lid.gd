extends CanvasLayer

@onready var fade_rect = $ColorRect
var tween: Tween

func init(is_open: bool) -> void:
	var color = Color(0,0,0,1.0)
	color.a = 0.0 if is_open else 1.0 
	fade_rect.modulate = color

func close_eyes(duration: float = 0.5) -> void:
	if tween:
		tween.kill() 
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate", Color(0, 0, 0, 1.0), duration) 
	await tween.finished

func open_eyes(duration: float = 0.5) -> void:
	if tween:
		tween.kill()  
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate", Color(0, 0, 0, 0.0), duration)
	await tween.finished
