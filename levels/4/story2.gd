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
	eye_lid.init(false)
	Main.play_bgm(5, 0)
	whole_scene.init(cam)
	whole_scene.set_house1_scene("outside")
	next_step()

var steps: Array = [
	func():
		step_ended = false
		eye_lid.open_eyes(3)
		man.direction = 0.75
		fairy.direction = 0.75
		await Global.wait(7)
		man.direction = 0
		fairy.direction = 0
		await Global.wait(0.5)
		next_step(),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_16")
		step_ended = true,
	func():
		speech_bubble.hide()
		step_ended = false
		man.direction = 0.75
		fairy.direction = 0.75,
	func():
		man.direction = 0 
		fairy.direction = 0
		await Global.wait(0.2)
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_17")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		man.direction = 0.75
		await Global.wait(1)
		man.direction = 0
		await Global.wait(2)
		next_step(),
	func():
		$Trap.queue_free()
		step_ended = true,
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_18")
		await Global.wait(1),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_19"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_20"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_21"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_22"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_23"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_24"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_25"),
	func():
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_26"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_27"),
	func():
		speech_bubble.set_dialogue(fairy.global_position, "LEVEL4_28"),
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
		fairy.direction = 0
		speech_bubble.set_dialogue(man.global_position, "LEVEL4_29")
		step_ended = true,
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
		Global.play_sound(audio, select_sound)
	else:
		ended.emit()

func _input(event):
	if event.is_action_pressed("ui_accept") and step_ended:
		next_step()

func _on_trap_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		next_step()
