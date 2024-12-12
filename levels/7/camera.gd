extends Camera2D

signal camera_transition_complete

@export var player: Node2D
@export var goal: Node2D

@export var transition_duration: float = 2.0
@export var easing_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var transition_type: Tween.TransitionType = Tween.TRANS_SINE


func move_to_player():
	global_position = goal.global_position
	var tween = create_tween()
	tween.set_ease(easing_type)
	tween.set_trans(transition_type)
	tween.tween_property(self, "global_position", player.global_position, transition_duration)
	tween.parallel().tween_property(self, "offset", Vector2(player.collision_shape.shape.size.x, -200.0) / zoom, transition_duration)
	tween.tween_callback(func():
		camera_transition_complete.emit()
	)
