extends Node

func is_node_valid(node) -> bool:
	return node != null and is_instance_valid(node) and not node.is_queued_for_deletion()
	
func get_valid_nodes_in_group(group_name: String) -> Array:
	return get_tree().get_nodes_in_group(group_name).filter(func(node):
		return is_node_valid(node)
	)

func get_zoom_factor():
	var screen_resolution = DisplayServer.window_get_size()
	var base_resolution = Vector2i(1920, 1080)
	var resolution_scale = screen_resolution / base_resolution
	var zoom_factor = Vector2.ONE * (0.5 / min(resolution_scale.x, resolution_scale.y))
	return zoom_factor
