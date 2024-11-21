extends Area2D

@export var speed: float = 1000.0
@export var lifetime: float = 5.0

var direction: Vector2 = Vector2.RIGHT

var damage = 20.0

func _ready():
	var timer = get_tree().create_timer(lifetime)
	await timer.timeout
	queue_free()

func _physics_process(delta):
	global_position += direction * speed * delta
