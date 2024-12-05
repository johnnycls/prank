extends Camera2D

@export var follow_speed: float = 5.0
@export var target: Node2D

func _physics_process(delta):
	if target:
		position = position.lerp(Vector2(target.position.x, 0), follow_speed * delta)
