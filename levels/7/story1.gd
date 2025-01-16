extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")
var daughter_scene = preload("res://characters/daughter.tscn")

var step_ended: bool = true

@onready var eye_lid = $EyeLid
@onready var warrior = $Warrior
@onready var castle_scene = $CastleScene
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2

var daughter

func _ready() -> void:
	Main.play_bgm(4, 0)
	eye_lid.init(false)
	castle_scene.set_scene("outside")
	next_step()

var steps: Array = [
	func():
		step_ended = false
		await eye_lid.open_eyes(3)
		next_step(),
	func():
		warrior.direction = 0.2
		await Global.wait(5)
		warrior.direction = 0
		await Global.wait(5)
		castle_scene.set_scene("interior", true)
		daughter = daughter_scene.instantiate()
		daughter.global_position = Vector2(3000, 750)
		add_child(daughter)
		await Global.wait(1)
		next_step(),
	func():
		speech_bubble.set_dialogue(daughter.global_position, "LEVEL7_0")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL7_1"),
	func():
		speech_bubble.set_dialogue(daughter.global_position, "LEVEL7_2"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL7_3"),
	func():
		speech_bubble.set_dialogue(daughter.global_position, "LEVEL7_4"),
	func():
		speech_bubble.set_dialogue(daughter.global_position, "LEVEL7_5"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL7_6"),
	func():
		speech_bubble.set_dialogue(daughter.global_position, "LEVEL7_7"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL7_8"),
	func():
		speech_bubble.set_dialogue(daughter.global_position, "LEVEL7_9"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL7_10"),
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL7_11"),
	func():
		speech_bubble.set_dialogue(daughter.global_position, "LEVEL7_12"),
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
