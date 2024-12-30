extends Camera2D

@export var follow_speed: float = 5.0
@export var target: Node2D

func _physics_process(delta):
	if enabled and target:
		position = position.lerp(Vector2(target.position.x, target.position.y - 150), follow_speed * delta)
