extends Area2D

@export var speed: float = 600.0

var player
var damage = 20.0

func _ready():
	player = Global.get_valid_nodes_in_group("players")[0]

func _physics_process(delta):
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
