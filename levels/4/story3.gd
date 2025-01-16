extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")
var door_open_sound = preload("res://assets/audio/door_open.wav")

var step_ended: bool = true

@onready var player = $Player
@onready var eye_lid = $EyeLid
@onready var man = $Man
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

func _ready() -> void:
	Main.play_bgm(4, 0)
	whole_scene.init(cam)
	whole_scene.set_house1_scene("interior")
	eye_lid.init(false)
	cam.global_position = whole_scene.house1_center()
	next_step()

var steps: Array = [
	func():
		step_ended = false
		await eye_lid.open_eyes(3)
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_44")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_45"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_46"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_47"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_48"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_49"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_50"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_51"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_52"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_53"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_54"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_55"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_56"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_57"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_58"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_59"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_60"),
	func():
		step_ended = false
		speech_bubble.hide()
		man.direction = 0.2
		await Global.wait(0.75)
		man.queue_free()
		Global.play_sound(audio2, door_open_sound)
		await Global.wait(3)
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_61")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_62"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_63"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_64"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_65"),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL4_66"),
	func():
		step_ended = false
		await eye_lid.close_eyes(3)
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
