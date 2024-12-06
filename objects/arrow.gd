extends Area2D

@export var initial_speed: float = 3000.0
@export var launch_angle: float = 0.0
@export var lifetime: float = 10.0
@export var acceleration_gravity: float = 200.0
@export var damage: float = 20.0

var velocity: Vector2

func set_angle(angle: float):
	launch_angle = angle
	_update_velocity_rotation()

func _update_velocity_rotation():
	var angle_rad = launch_angle
	velocity = Vector2(
		initial_speed * cos(angle_rad), 
		initial_speed * sin(angle_rad)
	)
	rotation = velocity.angle()

func _ready():
	_update_velocity_rotation()
	var timer = get_tree().create_timer(lifetime)
	await timer.timeout
	queue_free()

func _physics_process(delta):
	velocity.y += acceleration_gravity * delta
	global_position += velocity * delta
	rotation = velocity.angle()
