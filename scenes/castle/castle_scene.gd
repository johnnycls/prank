extends Node2D

signal castle_changed_scene(scene: String)


func _on_castle_changed_scene(scene: String) -> void:
	castle_changed_scene.emit(scene)
