extends Node2D

signal changed_scene(scene: String)

var outside_scene = preload("res://scenes/castle/outside.tscn")
var interior_scene = preload("res://scenes/castle/interior.tscn")
var kitchen_scene = preload("res://scenes/castle/kitchen.tscn")
var room_scene = preload("res://scenes/castle/room.tscn")

var open_door_sound = preload("res://assets/audio/door_open.wav")
var error_sound = preload("res://assets/audio/error.wav")

var scene

@onready var audio = $AudioStreamPlayer

func set_scene(_scene, audio_play: bool = false) -> void:
	if _scene=="outside":
		_on_outside_in(audio_play)
	elif _scene=="interior":
		_on_interior_in(audio_play)
	elif _scene=="kitchen":
		_on_kitchen_in(audio_play)
	elif _scene=="room":
		_on_room_in(audio_play)

func _on_outside_in(audio_play: bool = true) -> void:
	var outside = outside_scene.instantiate()
	if Global.is_node_valid(scene):
		scene.queue_free()
	outside.interior_in.connect(_on_interior_in)
	scene = outside
	add_child(outside)
	changed_scene.emit("outside")
	if audio_play:
		audio.stream = open_door_sound
		audio.play()

func _on_interior_in(audio_play: bool = true) -> void:
	var interior = interior_scene.instantiate()
	interior.interior_left.connect(_on_outside_in)
	interior.kitchen_in.connect(_on_kitchen_in)
	interior.room_in.connect(_on_room_in)
	interior.locked_door_in.connect(_on_locked_door_in)
	if Global.is_node_valid(scene):
		scene.queue_free()
	scene = interior
	add_child(interior)
	changed_scene.emit("interior")
	if audio_play:
		audio.stream = open_door_sound
		audio.play()

func _on_kitchen_in(audio_play: bool = true) -> void:
	var kitchen = kitchen_scene.instantiate()
	if Global.is_node_valid(scene):
		scene.queue_free()
	kitchen.kitchen_left.connect(_on_interior_in)
	scene = kitchen
	add_child(kitchen)
	changed_scene.emit("kitchen")
	if audio_play:
		audio.stream = open_door_sound
		audio.play()
	
func _on_room_in(audio_play: bool = true) -> void:
	var room = room_scene.instantiate()
	if Global.is_node_valid(scene):
		scene.queue_free()
	room.room_left.connect(_on_interior_in)
	scene = room
	add_child(room)
	changed_scene.emit("room")
	if audio_play:
		audio.stream = open_door_sound
		audio.play()

func _on_locked_door_in(audio_play: bool = true) -> void:
	if audio_play:
		audio.stream = error_sound
		audio.play()

func center() -> Vector2:
	return scene.get_node("Center").global_position
