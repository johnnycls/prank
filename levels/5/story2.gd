extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var player = $Player
@onready var speech_bubble = $SpeechBubble
@onready var cam = $PlayerFollowingCamera
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene
@onready var img = $CanvasLayer

func _ready() -> void:
	next_step()
	
var steps: Array = [
	func():
		step_ended = false
		await Global.wait(0.5)
		speech_bubble.set_dialogue(player.global_position, "LEVEL5_9")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL5_10"),
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.2
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		img.show()
		await Global.wait(3)
		step_ended = true,
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
