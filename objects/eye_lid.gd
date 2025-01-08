extends CanvasLayer

@onready var fade_rect = $ColorRect
var tween: Tween

func close_eyes(duration: float = 0.5):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
	await tween.finished

func open_eyes(duration: float = 0.5):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	await tween.finished

func blink(close_duration: float = 0.1, open_duration: float = 0.1):
	await close_eyes(close_duration)
	await open_eyes(open_duration)
