extends Node2D

signal story_ended(times: int)

var warrior = preload("res://characters/warrior_story.tscn").instantiate()
var select_sound = preload("res://assets/audio/select.wav")
var walk_sound = preload("res://assets/audio/walk.mp3")
var door_sound = preload("res://assets/audio/door_open_slowly.wav")
var sword_sound = preload("res://assets/audio/sword.wav")

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
		warrior.direction = 0.75
		player.is_jump_just_pressed = true
		player.is_jump_pressed = true
		player.direction = -1
		var timer = get_tree().create_timer(0.05)
		await timer.timeout
		warrior.direction = 0
		warrior.attack()
		timer = get_tree().create_timer(0.05)
		await timer.timeout
		player.is_jump_pressed = false
		player.direction = 0
		step_ended = true,
	func():
		speech_bubble.show()
		speech_bubble.set_dialogue(player.global_position,"LEVEL2_7"),
	func():
		speech_bubble.hide()
		cam.enabled = false
		story_ended.emit(0),
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
