extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var player = $Player
@onready var man = $Man
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

func _ready() -> void:
	next_step()
	
var steps: Array = [	
	func():
		step_ended = false
		player.global_position = Vector2(66500, 750)
		man.global_position = Vector2(66000, 750)
		cam.global_position = player.global_position
		speech_bubble.set_dialogue(man.global_position,"LEVEL3_14")
		await $EyeLid.close_eyes()
		step_ended = true,
]

var current_step: int = -1

func get_canva_pos(node: Node2D):
	return get_viewport().get_canvas_transform() * node.global_position

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
