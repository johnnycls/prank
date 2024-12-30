extends Node2D

signal story_ended(times: int)

var warrior_scene = preload("res://characters/warrior_story.tscn")
var select_sound = preload("res://assets/audio/select.wav")
var walk_sound = preload("res://assets/audio/walk.mp3")
var door_sound = preload("res://assets/audio/door_open_slowly.wav")
var door_open_sound = preload("res://assets/audio/door_open.wav")
var sword_sound = preload("res://assets/audio/sword.wav")

var warrior
var step_ended: bool = true

@onready var player: CharacterBody2D = $Player
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var audio = $AudioStreamPlayer
@onready var audio2 = $AudioStreamPlayer2
@onready var bg = $CanvasLayer/ColorRect

@export var whole_scene: Node2D

func select() -> void:
	audio.stream = select_sound
	audio.play()

var steps: Array = [
	func():
		whole_scene.player_following_cam = cam
		player.show()
		Main.play_bgm(2)
		step_ended = true
		bg.hide()
		cam.enabled = true
		cam.global_position = whole_scene.castle_center()
		player.global_position = Vector2(10200, -740)
		speech_bubble.show()
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
		audio2.stream = door_sound
		audio2.play()
		await audio2.finished
		next_step(),
	func():
		warrior = warrior_scene.instantiate()
		add_child(warrior)
		warrior.global_position = Vector2(9250, -740)
		step_ended = true,
	func():
		speech_bubble.show()
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_4"),
	func():
		step_ended = false
		speech_bubble.hide()
		warrior.direction = 0.1
		var timer = get_tree().create_timer(2)
		await timer.timeout
		warrior.direction = 0
		warrior.attack()
		player.direction = 0.75
		timer = get_tree().create_timer(0.05)
		await timer.timeout
		player.direction = 0
		next_step(),
	func():
		speech_bubble.show()
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_5")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_6"),
	func():
		speech_bubble.hide()
		step_ended = false
		warrior.direction = 1
		player.is_jump_just_pressed = true
		player.is_jump_pressed = true
		player.direction = -0.5
		var timer = get_tree().create_timer(0.15)
		await timer.timeout
		player.is_jump_pressed = false
		warrior.direction = 0
		warrior.attack()
		timer = get_tree().create_timer(0.5)
		await timer.timeout
		player.direction = 0
		timer = get_tree().create_timer(0.5)
		await timer.timeout
		warrior.direction = -0.3
		timer = get_tree().create_timer(0.5)
		await timer.timeout
		whole_scene.set_castle_scene("interior", true)
		warrior.queue_free()
		next_step(),
	func():
		speech_bubble.show()
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_7")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.5
		cam.target = player
		var timer = get_tree().create_timer(1)
		await timer.timeout
		audio2.stream = door_open_sound
		audio2.play()
		warrior = warrior_scene.instantiate()
		add_child(warrior)
		warrior.global_position = Vector2(9250, -740)
		warrior.direction = 0.5
		player.direction = 0.35
		player.is_jump_just_pressed = true
		player.is_jump_pressed = true
		timer = get_tree().create_timer(0.1)
		await timer.timeout
		player.is_jump_pressed = false
		timer = get_tree().create_timer(0.5)
		await timer.timeout
		warrior.direction = 0
		player.direction = 0
		timer = get_tree().create_timer(0.5)
		await timer.timeout
		next_step(),
	func():
		speech_bubble.show()
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
		var timer = get_tree().create_timer(0.5)
		await timer.timeout
		audio2.stream = door_open_sound
		audio2.play()
		warrior = warrior_scene.instantiate()
		add_child(warrior)
		warrior.global_position = Vector2(11450, 755)
		warrior.direction = 0.5
		timer = get_tree().create_timer(1)
		await timer.timeout
		warrior.direction = 0
		player.direction = 0
		timer = get_tree().create_timer(0.5)
		await timer.timeout
		next_step(),
	func():
		speech_bubble.show()
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
		var timer = get_tree().create_timer(5)
		await timer.timeout
		warrior.direction = 0
		player.direction = 0
		timer = get_tree().create_timer(1)
		await timer.timeout
		next_step(),
	func():
		speech_bubble.show()
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_16")
		step_ended = true,
	func():
		speech_bubble.set_dialogue(warrior.global_position,"LEVEL2_17"),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_18"),
	func():
		speech_bubble.hide()
		cam.enabled = false
		player.process_mode = Node.PROCESS_MODE_DISABLED
		player.hide()
		warrior.queue_free()
		story_ended.emit(0),
	func():
		player.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		pass
]

var current_step: int = -1

func get_canva_pos(node: Node2D):
	return get_viewport().get_canvas_transform() * node.global_position

func next_step():
	current_step += 1
	if current_step < steps.size():
		steps[current_step].call()
	else:
		speech_bubble.hide()
		await get_tree().create_timer(0.2).timeout
		cam.enabled = false
		player.hide()
		get_tree().paused = false
		story_ended.emit(1)
	select()

func _input(event):
	if event.is_action_pressed("ui_accept") and step_ended:
		next_step()
