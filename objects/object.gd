extends Area2D

signal player_enter()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		player_enter.emit()
		hide()
