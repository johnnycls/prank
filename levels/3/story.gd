extends Node2D

signal story_ended(times: int)

var player_scene = preload("res://characters/player_story.tscn")
var man_scene = preload("res://characters/man_story.tscn")
var select_sound = preload("res://assets/audio/select.wav")
var man_sound = preload("res://assets/audio/jump_scare.wav")

var player: CharacterBody2D
var man
var step_ended: bool = true

@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2

@export var whole_scene: Node2D

var steps: Array = [
	func():
		Main.play_bgm(4,0)
		whole_scene.init(cam)
		step_ended = false
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = Vector2(48000, 750)
		cam.global_position = player.global_position
		cam.enabled = true
		cam.target = player
		speech_bubble.hide()
		player.direction = 0.05
		await Global.wait(5)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_0")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.05
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_1")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.05
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_2")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.05
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_3")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.05
		await Global.wait(3)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_4")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.05
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
		player.direction = 0.05
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
	func():
		speech_bubble.hide()
		cam.enabled = false
		player.queue_free()
		story_ended.emit(0),	
	func():
		step_ended = false
		player = player_scene.instantiate()
		add_child.call_deferred(player)
		player.global_position = Vector2(50000, 750)
		cam.global_position = player.global_position
		cam.enabled = true
		cam.target = player
		player.direction = 0.4
		await Global.wait(5)
		man = man_scene.instantiate()
		add_child(man)
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
	func():
		cam.enabled = false
		player.queue_free()
		man.queue_free()
		story_ended.emit(1),	
	func():
		step_ended = false
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = Vector2(66500, 750)
		man = man_scene.instantiate()
		add_child(man)
		man.global_position = Vector2(66000, 750)
		cam.global_position = player.global_position
		cam.enabled = true
		cam.target = player
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
		await Global.wait(0.2)
		get_tree().paused = false
		story_ended.emit(2)
	Global.play_sound(audio, select_sound)

func _input(event):
	if event.is_action_pressed("ui_accept") and step_ended:
		next_step()
