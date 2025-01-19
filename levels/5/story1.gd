extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var player = $Player
@onready var warrior = $Warrior
@onready var man = $Man
@onready var speech_bubble = $SpeechBubble
@onready var cam = $PlayerFollowingCamera
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

func _ready() -> void:
	Main.stop_bgm()
	whole_scene.init(cam)
	whole_scene.set_house1_scene("outside")
	next_step()

var steps: Array = [
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL5_0"),
	func():
		step_ended = false
		speech_bubble.hide()
		man.direction = -0.3
		await Global.wait(2)
		man.direction = 0
		await Global.wait(0.5)
		next_step(),
	func():
		Main.play_bgm(3)
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL5_1")	
		step_ended = true,
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL5_2")	,
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL5_3")	,
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL5_4")	,
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL5_5")	,
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL5_6")	,
	func():
		speech_bubble.set_dialogue(warrior.global_position, "LEVEL5_7")	,
	func():
		step_ended = false
		speech_bubble.hide()
		cam.target = player
		await Global.wait(1)
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position, "LEVEL5_8")	
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
