extends CanvasLayer

@export var scroll_scale: float = 0.125
@export var repeat_pixels: int = 7680

var zoom_factor: float = 0.25

func _ready() -> void:
	scale = Vector2(zoom_factor, zoom_factor)

func set_offset_by_distance(distance: int) -> void:
	offset.x = -int(distance*zoom_factor*scroll_scale) % int(repeat_pixels*zoom_factor)
