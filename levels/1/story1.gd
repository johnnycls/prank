extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")
var walk_sound = preload("res://assets/audio/walk.mp3")
var eat_sound = preload("res://assets/audio/eat.wav")

@onready var player = $Player
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene
@onready var bg = $CanvasLayer/ColorRect

var step_ended: bool = true


func _ready() -> void:
	whole_scene.set_castle_scene("kitchen")
	next_step()

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
