extends Node2D

var arrow_scene = preload("res://objects/arrow.tscn")

@export var move_speed: float = 1250.0
@export var min_shoot_interval: float = 2.0
@export var max_shoot_interval: float = 3.0

@onready var shoot_timer: Timer

var player: CharacterBody2D
var damage = 10.0

func _ready():
	player = Global.get_valid_nodes_in_group("players")[0]
	_create_timer()
	
func _physics_process(delta: float) -> void:
	global_position.x += sign(player.global_position.x - global_position.x) * move_speed * delta

func _create_timer():
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(func():
		shoot_timer.queue_free()
		shoot()
	)
	var random_interval = randf_range(min_shoot_interval, max_shoot_interval)
	shoot_timer.start(random_interval)

func shoot():
	var arrow = arrow_scene.instantiate()
	arrow.set_angle(global_position.angle_to_point(player.global_position))
	get_parent().add_child(arrow)
	arrow.global_position = global_position
	_create_timer()
