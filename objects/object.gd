extends Area2D

@export var texture: Texture2D
@export var modulate_color: Color = Color.WHITE
@export var collision_scale: Vector2 = Vector2(1, 1)
@export var collision_offset: Vector2 = Vector2.ZERO

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D

signal player_enter()

func _ready():
	sprite.texture = texture
	sprite.modulate = modulate_color
	var shape = RectangleShape2D.new()
	var texture_size = sprite.texture.get_size() * collision_scale
	shape.extents = texture_size / 2
	collision_shape.shape = shape
	collision_shape.position = collision_offset

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		player_enter.emit()
		hide()
