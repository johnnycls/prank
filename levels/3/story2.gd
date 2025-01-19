extends Node2D

signal ended

var man_sound = preload("res://assets/audio/jump_scare.wav")
var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var player = $Player
@onready var man = $Man
@onready var speech_bubble = $SpeechBubble
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

func _ready() -> void:
	next_step()
	
var steps: Array = [
	func():
			step_ended = false
			player.direction = 0.4
			await Global.wait(5)
			man.global_position = Vector2(player.global_position.x-250, player.global_position.y)
			Global.play_sound(audio2, man_sound)
			player.direction = 0
			next_step(),
		func():
			speech_bubble.set_dialogue(man.global_position,"LEVEL3_12")
			step_ended = true,
		func():
			step_ended = false
			speech_bubble.hide()
			player.direction = 0.5
			await Global.wait(0.5)
			player.direction = 0
			await Global.wait(0.2)
			next_step(),
		func():
			speech_bubble.set_dialogue(man.global_position,"LEVEL3_13")
			step_ended = true,
		func():
			step_ended = false
			speech_bubble.hide()
			player.direction = 0.5
			man.direction = 0.5
			await Global.wait(1)
			player.direction = 0
			man.direction = 0
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
