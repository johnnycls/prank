extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var player = $Player
@onready var child = $Child
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2

func _ready() -> void:
	Main.play_bgm(4, 0)
	next_step()

var steps: Array = [
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL6_13"),
	func():
		speech_bubble.set_dialogue(child.global_position, "LEVEL6_14"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL6_15"),
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
