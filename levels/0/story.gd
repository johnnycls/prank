extends Node2D

signal story_ended

var select_sound = preload("res://assets/audio/select.wav")
@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@onready var bg = $CanvasLayer/ColorRect
@onready var label = $CanvasLayer/MarginContainer/Label
@onready var audio = $AudioStreamPlayer

@export var player: CharacterBody2D

func select() -> void:
	audio.stream = select_sound
	audio.play()

var steps: Array = [
	func():
		cam.enabled = false
		label.show()
		label.text = "LEVEL0_0",
	func():
		label.text = "LEVEL0_1",
	func():
		label.hide()
		bg.hide()
		cam.enabled = true
		cam.position = player.position,
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_2"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_3"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_4"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_5"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_6"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_7"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_8"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_9"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_10"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_11"),
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
		cam.enabled = false
		get_tree().paused = false
		story_ended.emit()
	select()

func _ready() -> void:
	next_step()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next_step()
