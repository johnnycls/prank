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

func init(scene: String)-> void:
	castle.init(scene)

func center() -> Vector2:
	return castle.center()
