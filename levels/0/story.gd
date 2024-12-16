extends Node2D

signal story_ended

@onready var speech_bubble = $SpeechBubble
@onready var cam = $Camera2D
@export var player: CharacterBody2D

var steps: Array = [
	func():
		cam.position = player.position
		speech_bubble.set_dialogue(player.position,"LEVEL0_0"),
	func():
		speech_bubble.set_dialogue(player.position,"LEVEL0_1"),
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
		story_ended.emit()

func _ready() -> void:
	next_step()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next_step()
