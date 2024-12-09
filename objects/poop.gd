extends Area2D

@export var initial_speed: float = 3500.0
@export var launch_angle: float = 0.0
@export var acceleration_gravity: float = 2500.0
@export var damage: float = 20.0

var velocity: Vector2

func init(direction: Vector2, _init_speed: float):
	initial_speed = _init_speed
	velocity = direction * initial_speed
	rotation = velocity.angle()

func _physics_process(delta):
	velocity.y += acceleration_gravity * delta
	global_position += velocity * delta
	rotation = velocity.angle()
	
	if global_position.y>2160.0:
		queue_free()
