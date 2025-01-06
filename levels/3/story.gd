extends Node2D

signal story_ended(times: int)

var player_scene = preload("res://characters/player_story.tscn")
var warrior_scene = preload("res://characters/warrior_story.tscn")
var select_sound = preload("res://assets/audio/select.wav")

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
		Main.play_bgm(4,0)
		whole_scene.init(cam)
		step_ended = false
		player = player_scene.instantiate()
		add_child(player)
		player.global_position = Vector2(48000, 740)
		cam.global_position = player.global_position
		cam.enabled = true
		cam.target = player
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(2)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_0")
		step_ended = true,
	func():
		step_ended = false
		speech_bubble.hide()
		player.direction = 0.1
		await Global.wait(2)
		player.direction = 0
		next_step(),
	func():
		speech_bubble.set_dialogue(player.global_position,"LEVEL3_1")
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
		story_ended.emit(1)
	select()

func _input(event):
	if event.is_action_pressed("ui_accept") and step_ended:
		next_step()
