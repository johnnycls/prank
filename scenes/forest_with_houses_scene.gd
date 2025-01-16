extends Node2D

signal house1_changed_scene(scene: String)

@onready var ground = $Floor
@onready var house1 = $House1
@onready var house2 = $House2

func _on_house1_changed_scene(scene: String) -> void:
	if scene!="outside":
		if Global.is_node_valid(ground):
			ground.hide()
		if Global.is_node_valid(house2):
			house2.hide()
	else:
		if Global.is_node_valid(ground):
			ground.show()
		if Global.is_node_valid(house2):
			house2.show()
	house1_changed_scene.emit(scene)

func set_scene(scene: String, audio_play: bool = false) -> void:
	house1.set_scene(scene, audio_play)

func center() -> Vector2:
	return house1.center()
