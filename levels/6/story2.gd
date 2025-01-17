extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var eye_lid = $EyeLid
@onready var fairy = $Fairy
@onready var warrior = $Warrior
@onready var speech_bubble = $SpeechBubble
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2

func _ready() -> void:
	eye_lid.init(true)
	next_step()

var steps: Array = [
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_12"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_13"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_14"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_15"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_16"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_17"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_18"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_19"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_20"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_21"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL6_22"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL6_23"),
	func():
		step_ended = false
		speech_bubble.hide()
		await eye_lid.close_eyes(3)
		step_ended = true
		next_step(),
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
