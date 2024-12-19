extends AudioStreamPlayer

@onready var select_sound = preload("res://assets/audio/select.wav")

func select() -> void:
	stream = select_sound
	play()
