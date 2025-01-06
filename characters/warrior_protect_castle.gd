extends Area2D

var damage: float = 10000.0

@export var player: CharacterBody2D

@onready var attack_audio = $AttackAudio

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		attack_audio.play()

func _physics_process(_delta: float) -> void:
	if Global.is_node_valid(player):
		global_position.y = min(755, player.global_position.y)
