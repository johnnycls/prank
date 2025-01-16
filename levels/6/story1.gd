extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var fairy = $Fairy
@onready var warrior = $Warrior
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2

func _ready() -> void:
	Main.play_bgm(4, 0)
	next_step()

var steps: Array = [
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_0"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_1"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_2"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_3"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_4"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_5"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_6"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_7"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_8"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_9"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_10"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_11"),
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
