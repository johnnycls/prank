extends Area2D

signal eaten

var food_points: float = 10

func on_eaten() -> void:
	eaten.emit()
	queue_free()	
