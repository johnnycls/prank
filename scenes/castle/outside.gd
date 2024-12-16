extends Node2D

signal interior_in

func _on_door_enter() -> void:
	interior_in.emit()
