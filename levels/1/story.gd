extends Node2D

signal story_ended(times: int)

var warrior = preload("res://characters/warrior_story.tscn").instantiate()
var select_sound = preload("res://assets/audio/select.wav")
var walk_sound = preload("res://assets/audio/walk.mp3")
var door_sound = preload("res://assets/audio/door_open.wav")
var eat_sound = preload("res://assets/audio/eat.wav")

var step_ended: bool = true

@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var bg = $CanvasLayer/ColorRect

@export var player: CharacterBody2D
@export var whole_scene: Node2D

func select() -> void:
	audio.stream = select_sound
	audio.play()

var steps: Array = [
	func():
		Main.play_bgm(0,0)
		speech_bubble.hide()
		step_ended = false
		audio2.stream = eat_sound
		audio2.play()
		await audio2.finished
		next_step(),
	func():
		step_ended = true
		bg.hide()
		cam.enabled = true
		cam.global_position = whole_scene.castle_center()
		speech_bubble.show()
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_0"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_1"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_2"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_3"),
	func():
		speech_bubble.hide()
		step_ended = false
		audio2.stream = walk_sound
		audio2.play()
		await audio2.finished
		next_step(),
	func():
		speech_bubble.show()
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_4")
		step_ended = true,
	func():
		speech_bubble.hide()
		cam.enabled = false
		story_ended.emit(0),
	func():
		Main.play_bgm(2,0)
		speech_bubble.show()
		player.global_position = Vector2(10300, -740)
		cam.global_position = whole_scene.castle_center()
		cam.enabled = true
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_5"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_6"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_7"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_8"),
	func():
		Main.stop_bgm()
		step_ended = false
		speech_bubble.hide()
		audio2.stream = door_sound
		audio2.play()
		add_child(warrior)
		warrior.global_position = Vector2(9250, -740)
		await audio2.finished
		next_step(),
	func():
		speech_bubble.show()
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL1_9")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_10"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_11"),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL1_12"),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL1_13"),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL1_14"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_15"),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL1_16"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_17"),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL1_18"),
	func():
		step_ended = false
		speech_bubble.hide()
		audio2.stream = door_sound
		audio2.play()
		warrior.queue_free()
		await audio2.finished
		next_step(),
	func():
		Main.play_bgm(2,0)
		speech_bubble.show()
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_19")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_20"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_21"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_22"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_23"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL1_24"),
]

var current_step: int = -1

func get_canva_pos(node: Node2D):
	return get_viewport().get_canvas_transform() * node.global_position

func next_step():
	current_step += 1
	if current_step < steps.size():
		steps[current_step].call()
	else:
		speech_bubble.hide()
		await get_tree().create_timer(0.2).timeout
		cam.enabled = false
		get_tree().paused = false
		story_ended.emit(1)
	select()

func _ready() -> void:
		next_step()

func _input(event):
	if event.is_action_pressed("ui_accept") and step_ended:
		next_step()
