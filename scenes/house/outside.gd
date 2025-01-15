extends Node2D

signal enter

func _on_door_enter() -> void:
	enter.emit()
