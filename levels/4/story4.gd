extends Node2D

signal ended

var select_sound = preload("res://assets/audio/select.wav")

var step_ended: bool = true

@onready var eye_lid = $EyeLid
@onready var fairy = $Fairy
@onready var man = $Man
@onready var speech_bubble = $SpeechBubble
@onready var cam = $PlayerFollowingCamera
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var whole_scene = $WholeScene

func _ready() -> void:
	eye_lid.init(true)
	Main.play_bgm(5, 0)
	whole_scene.init(cam)
	whole_scene.set_house1_scene("outside")
	next_step()

var steps: Array = [
	func():
		step_ended = false
		fairy.direction = -0.5
		fairy.is_jump_just_pressed = true
		fairy.is_jump_pressed = true
		await Global.wait(1)
		fairy.is_jump_just_pressed = true
		fairy.is_jump_pressed = true
		await Global.wait(0.5)
		fairy.direction = 0
		await Global.wait(1)
		next_step(),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_34")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_35"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_36"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_37"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_38"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_39"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_40"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_41"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_42"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_43"),
	func():
		step_ended = false
		speech_bubble.hide()
		fairy.direction = 0.75
		fairy.is_jump_just_pressed = true
		fairy.is_jump_pressed = true
		await Global.wait(0.5)
		fairy.is_jump_just_pressed = true
		fairy.is_jump_pressed = true
		await Global.wait(0.5)
		fairy.is_jump_just_pressed = true
		fairy.is_jump_pressed = true
		await Global.wait(0.5)
		fairy.is_jump_just_pressed = true
		fairy.is_jump_pressed = true
		next_step(),
	func():
		step_ended = false
		fairy.queue_free()
		await eye_lid.close_eyes(3)
		next_step(),
]

var current_step: int = -1

func next_step():
	current_step += 1
	if current_step < steps.size():
		steps[current_step].call()
		Global.play_sound(audio, select_sound)
	else:
		ended.emit()

func _input(event):
	if event.is_action_pressed("ui_accept") and step_ended:
		next_step()
	elif event.is_action_pressed("skip_story"):
		ended.emit()

func _on_trap_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		next_step()
