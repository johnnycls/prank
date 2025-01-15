extends Node2D

signal left

func _on_door_enter() -> void:
	left.emit()
