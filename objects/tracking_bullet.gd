extends Area2D

@export var speed: float = 600.0

var player
var damage = 20.0

func _ready():
	player = Global.get_valid_nodes_in_group("players")[0]
	queue_free()

func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	queue_free()
