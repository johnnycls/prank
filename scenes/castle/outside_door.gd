extends Area2D

signal enter

var is_inside: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		is_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		is_inside = false

func _unhandled_input(event: InputEvent) -> void:
	if is_inside and event.is_action_pressed("ui_accept"):
		enter.emit()
