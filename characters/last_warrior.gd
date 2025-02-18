extends Area2D

signal died

var fireball_scene: PackedScene = preload("res://objects/fireball.tscn")
var eat_sound = preload("res://assets/audio/eat_catus.mp3")
var eat_sound_2 = preload("res://assets/audio/eat_catus_2.mp3")

@export var move_speed: float = 250.0
@export var hungry_drain_rate: float = 2.0
@export var shoot_cooldown: float = 2.0
@export var player: CharacterBody2D

@onready var hp_label = $HPLabel
@onready var shoot_timer = $ShootTimer
@onready var audio = $AudioStreamPlayer

var damage = 10.0
var hp: float = 100.0

var target

func init():
	hp = 100.0

func _ready():
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.connect("timeout", _shoot_fireball)

func _physics_process(delta):
	hp -= hungry_drain_rate * delta
	hp_label.text = "%.2f" % hp + "/ 100"
	check_death()

	target = find_nearest_target()
	if Global.is_node_valid(target):
		var direction = -1 if target.global_position.x < global_position.x else 1
		var velocity = direction * move_speed
		if velocity>=0:
			$TextureRect.flip_h = true
		else:
			$TextureRect.flip_h = false
		global_position.x += velocity * delta

func find_nearest_target():
	var targets = Global.get_valid_nodes_in_group("foods")
	
	return targets.reduce(func(closest, current):
		var closest_dist = closest.global_position.distance_to(global_position) if Global.is_node_valid(closest) else INF
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
	if hp <= 0:
		died.emit()
		queue_free()

func eat_food(food_points: float):
	hp += food_points
	hp_label.text = "%.2f" % hp + "/ 100"

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("foods"):
		Global.play_sound(audio, eat_sound if randf()<0.5 else eat_sound_2)
		eat_food(area.food_points)
		area.on_eaten()
