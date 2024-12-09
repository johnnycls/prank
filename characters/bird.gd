extends Node2D

var poop_scene = preload("res://objects/poop.tscn")

@export var speed: float
@export var min_shoot_interval: float = 1.0
@export var max_shoot_interval: float = 1.5

@export var concurrent_poop: int
@export var angle: float = 0.1
@export var angle_inc: float = 0.05

var direction: Vector2
var player: CharacterBody2D
var damage = 10.0

func init(start_pos: Vector2, _direction: Vector2, _speed: float = 2500.0, _concurrent_poop: int = 4):
	global_position = start_pos
	direction = _direction
	speed = _speed
	concurrent_poop = _concurrent_poop

func _ready():
	player = Global.get_valid_nodes_in_group("players")[0]
	_create_timer()
	
func _physics_process(delta: float) -> void:
	global_position += speed * delta * direction

func _create_timer():
	var shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(func():
		shoot()
		shoot_timer.queue_free()
	)
	var random_interval = randf_range(min_shoot_interval, max_shoot_interval)
	shoot_timer.start(random_interval)

func shoot():
	var total_angle = angle + angle_inc*concurrent_poop
	for i in range(concurrent_poop):
		var poop = poop_scene.instantiate()
		poop.init(global_position.angle_to_point(player.global_position) + angle + randf_range(-total_angle, total_angle), randf_range(2500, 3500))
		get_parent().add_child(poop)
		poop.global_position = global_position
	_create_timer()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
