extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var eye_lid = $EyeLid
@onready var player = $Player
@onready var man = $Man
@onready var speech_bubble = $SpeechBubble
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

func _ready() -> void:
	eye_lid.init(true)
	next_step()
	
var steps: Array = [	
	func():
		speech_bubble.set_dialogue(man.global_position,"LEVEL3_14"),
	func():
		step_ended = false
		await eye_lid.close_eyes(4)
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
	elif event.is_action_pressed("skip_story"):
		ended.emit()
