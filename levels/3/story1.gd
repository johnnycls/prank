extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var player = $Player
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

func _ready() -> void:
	Main.play_bgm(4, 0)
	whole_scene.init(cam)
	next_step()

var steps: Array = [
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(5)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_0")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_1")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_2")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_3")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_4")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(5)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_5")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_6"),
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_7")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_8"),
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.05
		await Global.wait(5)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_9")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_10"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_11"),
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
