extends Node

func is_node_valid(node) -> bool:
	return node != null and is_instance_valid(node) and not node.is_queued_for_deletion()
	
func get_valid_nodes_in_group(group_name: String) -> Array:
	return get_tree().get_nodes_in_group(group_name).filter(func(node):
		return is_node_valid(node)
	)

func move_with_tween(object: Node2D, target_pos: Vector2, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(object, "global_position", target_pos, duration)
	# tween.set_trans(Tween.TRANS_CUBIC)
	# tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
