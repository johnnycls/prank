extends Node2D

signal room_left

func _on_room_door_enter() -> void:
	room_left.emit()
