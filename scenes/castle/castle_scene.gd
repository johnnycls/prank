extends Node2D

signal castle_changed_scene(scene: String)

@onready var ground = $Floor
@onready var castle = $Castle

func _on_castle_changed_scene(scene: String) -> void:
	if scene!="outside":
		if ground:
			ground.hide()
	else:
		if ground:
			ground.show()
	castle_changed_scene.emit(scene)

func set_scene(scene: String, audio_play: bool = false)-> void:
	castle.set_scene(scene, audio_play)

func center() -> Vector2:
	return castle.center()
