extends Area2D

@export var initial_speed: float = 3000.0
@export var launch_angle: float = 0.0
@export var acceleration_gravity: float = 1000.0
@export var damage: float = 20.0

var velocity: Vector2

func init(angle: float, init_speed: float):
	launch_angle = angle
	initial_speed = init_speed
	velocity = Vector2(
		initial_speed * cos(launch_angle), 
		initial_speed * sin(launch_angle)
	)
	rotation = velocity.angle()

func _physics_process(delta):
	velocity.y += acceleration_gravity * delta
	global_position += velocity * delta
	rotation = velocity.angle()
	
	if global_position.y>2160.0:
		queue_free()
