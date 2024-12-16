extends Node2D

signal kitchen_left

func _on_kitchen_door_enter() -> void:
	kitchen_left.emit()
