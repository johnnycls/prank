extends Control

@onready var character1 = $Character1
@onready var character2 = $Character2
@onready var dialogue_box = $DialogueBox
@onready var dialogue = $Dialogue

var steps: Array = [
	func():
		set_dialogue("LEVEL0_0"),
	func():
		set_dialogue("LEVEL0_1")
]
var current_step: int = 0

func _ready() -> void:
	steps[current_step].call()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		current_step += 1
		if current_step < steps.size():
			steps[current_step].call()
		else:
			Main.end_story()

func set_character1(img, is_hiden: bool = false):
	if is_hiden:
		character1.hide()
	else:
		character1.show()
	
func set_character2(img, is_hiden: bool = false):
	if is_hiden:
		character2.hide()
	else:
		character2.show()

func set_dialogue(text: String):
	dialogue.text = text
