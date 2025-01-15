extends Node2D

signal changed_scene(scene: String)

var outside_scene = preload("res://scenes/house/outside.tscn")
var interior_scene = preload("res://scenes/house/interior.tscn")

var open_door_sound = preload("res://assets/audio/door_open.wav")

var scene

@onready var audio = $AudioStreamPlayer

func set_scene(_scene, audio_play: bool = false) -> void:
	if _scene=="outside":
		_on_outside_in(audio_play)
	elif _scene=="interior":
		_on_interior_in(audio_play)

func _on_outside_in(audio_play: bool = true) -> void:
	var outside = outside_scene.instantiate()
	if Global.is_node_valid(scene):
		scene.queue_free()
	outside.enter.connect(_on_interior_in)
	scene = outside
	add_child(outside)
	changed_scene.emit("outside")
	if audio_play:
		audio.stream = open_door_sound
		audio.play()

func _on_interior_in(audio_play: bool = true) -> void:
	var interior = interior_scene.instantiate()
	interior.left.connect(_on_outside_in)
	if Global.is_node_valid(scene):
		scene.queue_free()
	scene = interior
	add_child(interior)
	changed_scene.emit("interior")
	if audio_play:
		audio.stream = open_door_sound
		audio.play()

func center() -> Vector2:
	return scene.get_node("Center").global_position
