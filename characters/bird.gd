extends Node2D

var poop_scene = preload("res://objects/poop.tscn")

@export var damage = 10.0
@export var angle: float = 0.05
@export var angle_inc: float = 0.05

var speed: float
var min_shoot_interval: float
var max_shoot_interval: float
var concurrent_poop: int
var direction: Vector2
var player: CharacterBody2D

func init(start_pos: Vector2, _direction: Vector2, _speed: float, _concurrent_poop: int, _min_shoot_interval: float, _max_shoot_interval: float):
	global_position = start_pos
	direction = _direction
	speed = _speed
	concurrent_poop = _concurrent_poop
	min_shoot_interval = _min_shoot_interval
	max_shoot_interval = _max_shoot_interval

func _ready():
	player = Global.get_valid_nodes_in_group("players")[0]
	_create_timer()
	
func _physics_process(delta: float) -> void:
	global_position += speed * delta * direction

func _create_timer():
	var shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(func():
		shoot()
		shoot_timer.queue_free()
	)
	var random_interval = randf_range(min_shoot_interval, max_shoot_interval)
	add_child(shoot_timer)
	shoot_timer.start(random_interval)

func shoot():
	var total_angle = angle + angle_inc*concurrent_poop
	for i in range(concurrent_poop):
		var poop = poop_scene.instantiate()
		poop.init(global_position.direction_to(player.global_position).rotated(randf_range(-total_angle, total_angle)), randf_range(2500, 3500))
		get_parent().add_child(poop)
		poop.global_position = global_position
	_create_timer()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
