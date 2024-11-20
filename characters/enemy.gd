extends Area2D

signal died

var fireball_scene: PackedScene = preload("res://objects/fireball.tscn")

@export var move_speed: float = 250.0
@export var hungry_drain_rate: float = 2.0
@export var shoot_cooldown: float = 2.0
@export var player: CharacterBody2D

@onready var health_label = $HealthLabel
@onready var shoot_timer = $ShootTimer

var hungry_points: float = 100.0
var target

func _ready():
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.connect("timeout", _shoot_fireball)

func _physics_process(delta):
	hungry_points -= hungry_drain_rate * delta
	health_label.text = "%.2f" % hungry_points + "/ 100"
	check_death()

	if Global.is_node_valid(target):
		var direction = (target.global_position - global_position).normalized()
		var velocity = direction * move_speed
		global_position = global_position + velocity * delta
	else:
		target = find_nearest_target()

func find_nearest_target():
	var targets = Global.get_valid_nodes_in_group("foods")
	print(targets.size())
	
	return targets.reduce(func(closest, current):
		var closest_dist = closest.global_position.distance_to(global_position) if closest else INF
		var current_dist = current.global_position.distance_to(global_position)
		return current if current_dist < closest_dist else closest
	)

func _shoot_fireball():
	var fireball = fireball_scene.instantiate()
	fireball.direction = (player.global_position - global_position).normalized()
	get_parent().add_child(fireball)
	fireball.global_position = global_position
	shoot_timer.start()

func check_death():
	if hungry_points <= 0:
		died.emit()
		queue_free()

func eat_food(food_points: float):
	hungry_points += food_points
	health_label.text = "%.2f" % hungry_points + "/ 100"
