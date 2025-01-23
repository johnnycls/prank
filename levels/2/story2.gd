extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")
var door_sound = preload("res://assets/audio/door_open_slowly.wav")
var door_open_sound = preload("res://assets/audio/door_open.wav")

@onready var player = $Player
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

var step_ended: bool = true

func _ready() -> void:
	next_step()

var steps: Array = [
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_19"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_20"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_21"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_22"),
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
	elif event.is_action_pressed("skip_story"):
		ended.emit()
