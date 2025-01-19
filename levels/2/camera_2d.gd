extends Camera2D

@export var follow_speed: float = 5.0
@export var target: Node2D
@export var y_offset: float = -150

func _physics_process(delta):
	if enabled and Global.is_node_valid(target):
		position = position.lerp(Vector2(target.position.x, target.position.y + y_offset), follow_speed * delta)
