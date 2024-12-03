extends Control

@onready var speech_bubble = $SpeechBubble

var player

var steps: Array = [
	func():
		speech_bubble.set_dialogue(get_canva_pos(player),"LEVEL0_0"),
	func():
		speech_bubble.set_dialogue(get_canva_pos(player),"LEVEL0_1"),
]
var current_step: int = -1

func get_canva_pos(node: Node2D):
	return get_viewport().get_canvas_transform() * node.global_position

func next_step():
	current_step += 1
	if current_step < steps.size():
		steps[current_step].call()
	else:
		Main.end_story()

func _ready() -> void:
	player = get_tree().get_first_node_in_group("players")
	next_step()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		next_step()
