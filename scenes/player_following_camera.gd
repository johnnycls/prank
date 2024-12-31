extends Camera2D

@export var follow_speed: float = 5.0
@export var y_coordinate: float = 0.0
@export var target: Node2D

func _physics_process(delta):
	if enabled and Global.is_node_valid(target):
		position = position.lerp(Vector2(target.position.x, y_coordinate), follow_speed * delta)
