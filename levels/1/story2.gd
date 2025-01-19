extends Node2D

signal ended

var warrior_scene = preload("res://characters/warrior_story.tscn")
var select_sound = preload("res://assets/audio/select.wav")
var walk_sound = preload("res://assets/audio/walk.mp3")
var door_sound = preload("res://assets/audio/door_open.wav")
var eat_sound = preload("res://assets/audio/eat.wav")

@onready var player = $Player
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

var step_ended: bool = true
var warrior

func _ready() -> void:
	Main.play_bgm(2)
	whole_scene.set_castle_scene("room")
	cam.global_position = whole_scene.castle_center()
	step_ended = false
	await get_tree().process_frame
	next_step()

var steps: Array = [
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL1_5")
		step_ended = true,
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
		warrior = warrior_scene.instantiate()
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
		warrior.queue_free()
		await Global.play_sound(audio2, door_sound, true)
		next_step(),
	func():
		Main.play_bgm(2)
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

func next_step():
	current_step += 1
	if current_step < steps.size():
		steps[current_step].call()
	else:
		ended.emit()
	Global.play_sound(audio, select_sound)

func _input(event):
	if event.is_action_pressed("ui_accept") and step_ended:
		next_step()
