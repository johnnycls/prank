extends Area2D

var damage: float = 10000.0

@export var player: CharacterBody2D
@export var speed: float = 2500.0

@onready var attack_audio = $AttackAudio

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		attack_audio.play()

func _physics_process(delta: float) -> void:
	if Global.is_node_valid(player):		
		var target_x = player.global_position.x
		var max_movement = speed * delta
		var new_x = move_toward(global_position.x, target_x, max_movement)
		global_position.x = new_x
