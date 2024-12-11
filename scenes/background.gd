extends CanvasLayer

@export var scroll_scale: float = 0.125
@export var repeat_pixels: float = 1920

var zoom_factor: float = 1.0

func set_offset_by_distance(distance: int) -> void:
	offset.x = -int(distance * zoom_factor) % int(repeat_pixels/scroll_scale) * scroll_scale

func set_zoom(_zoom_factor: float) -> void:
	zoom_factor = _zoom_factor
	scale = Vector2(zoom_factor, zoom_factor)
