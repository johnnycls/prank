extends Area2D

@export var initial_speed: float = 1000.0
@export var launch_angle: float = -45.0
@export var lifetime: float = 5.0
@export var acceleration_gravity: float = 980.0
@export var piercing: bool = false
@export var damage: float = 20.0

var velocity: Vector2

func _ready():
	var angle_rad = deg_to_rad(launch_angle)
	velocity = Vector2(
		initial_speed * cos(angle_rad), 
		initial_speed * sin(angle_rad)
	)
	rotation = velocity.angle()
	var timer = get_tree().create_timer(lifetime)
	await timer.timeout
	queue_free()

func _physics_process(delta):
	velocity.y += acceleration_gravity * delta
	global_position += velocity * delta
	rotation = velocity.angle()
