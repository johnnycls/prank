extends Node2D

signal story_ended(times: int)

var player_scene = preload("res://characters/player_story.tscn")
var warrior_scene = preload("res://characters/warrior_story.tscn")
var select_sound = preload("res://assets/audio/select.wav")
var walk_sound = preload("res://assets/audio/walk.mp3")
var door_sound = preload("res://assets/audio/door_open_slowly.wav")
var door_open_sound = preload("res://assets/audio/door_open.wav")
var sword_sound = preload("res://assets/audio/sword.wav")

var player: CharacterBody2D
var warrior
var step_ended: bool = true

@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2

@export var whole_scene: Node2D

func select() -> void:
	audio.stream = select_sound
	audio.play()

var steps: Array = [
	func():
		Main.play_bgm(2,0)
		whole_scene.init(cam)
		step_ended = true
		cam.enabled = true
		cam.global_position = whole_scene.castle_center()
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = Vector2(10200, -740)
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_0"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_1"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_2"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_3"),
	func():
		Main.stop_bgm()
		step_ended = false
		speech_bubble.hide()
		await Global.play_sound(audio2, door_sound, true)
		next_step(),
	func():
		warrior = warrior_scene.instantiate()
		add_child(warrior)
		warrior.global_position = Vector2(9250, -740)
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_4"),
	func():
		step_ended = false
		speech_bubble.hide()
		warrior.direction = 0.1
		await Global.wait(2)
		warrior.direction = 0
		warrior.attack()
		player.direction = 0.75
		await Global.wait(0.05)
		player.direction = 0
		Main.play_bgm(3, 0)
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_5")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_6"),
	func():
		step_ended = false
		speech_bubble.hide()
		warrior.direction = 1
		player.is_jump_just_pressed = true
		player.is_jump_pressed = true
		player.direction = -0.5
		await Global.wait(0.15)
		player.is_jump_pressed = false
		warrior.direction = 0
		warrior.attack()
		await Global.wait(0.5)
		player.direction = 0
		await Global.wait(0.5)
		warrior.direction = -0.3
		await Global.wait(0.5)
		whole_scene.set_castle_scene("interior", true)
		warrior.queue_free()
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_7")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.5
		cam.target = player
		await Global.wait(1)
		Global.play_sound(audio2, door_open_sound)
		warrior = warrior_scene.instantiate()
		add_child(warrior)
		warrior.global_position = Vector2(9250, -740)
		warrior.direction = 0.5
		player.direction = 0.35
		player.is_jump_just_pressed = true
		player.is_jump_pressed = true
		await Global.wait(0.1)
		player.is_jump_pressed = false
		await Global.wait(0.5)
		warrior.direction = 0
		player.direction = 0
		await Global.wait(0.5)
		next_step(),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_8")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_9"),
	func():
		step_ended = false
		speech_bubble.hide()
		whole_scene.set_castle_scene("outside", true)
		warrior.queue_free()
		player.direction = 0.5
		await Global.wait(0.5)
		Global.play_sound(audio2, door_open_sound)
		warrior = warrior_scene.instantiate()
		add_child(warrior)
		warrior.global_position = Vector2(11450, 755)
		warrior.direction = 0.5
		await Global.wait(1)
		warrior.direction = 0
		player.direction = 0
		await Global.wait(0.5)
		next_step(),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_10")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_11"),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_12"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_13"),
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_14"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_15"),
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.5
		warrior.direction = 0.5
		await Global.wait(5)
		warrior.direction = 0
		player.direction = 0
		await Global.wait(1)
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_16")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_17"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_18"),
	func():
		speech_bubble.hide()
		cam.enabled = false
		player.queue_free()
		warrior.queue_free()
		story_ended.emit(0),
	func():
		Main.play_bgm(4)
		player = player_scene.instantiate()
		add_child.call_deferred(player)
		player.global_position = Vector2(48000, 755)
		cam.global_position.x = player.global_position.x
		cam.target = player
		cam.enabled = true
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_19"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_20"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_21"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_22"),
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
		story_ended.emit(1)
	select()

func _input(event):
	if event.is_action_pressed("ui_accept") and step_ended:
		next_step()
