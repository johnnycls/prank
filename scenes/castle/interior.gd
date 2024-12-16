extends Node2D

signal interior_left
signal kitchen_in
signal room_in

func _on_door_enter() -> void:
	interior_left.emit()

func _on_kitchen_door_enter() -> void:
	kitchen_in.emit()

func _on_room_door_enter() -> void:
	room_in.emit()
