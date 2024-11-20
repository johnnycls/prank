extends Area2D

signal eaten(eaten_by)

func _on_area_entered(area: Area2D) -> void:
	eaten.emit(area)

func _on_body_entered(body: Node2D) -> void:
	eaten.emit(body)
