extends Node

func is_node_valid(node) -> bool:
	return node != null and is_instance_valid(node) and not node.is_queued_for_deletion()
	
func get_valid_nodes_in_group(group_name: String) -> Array:
	return get_tree().get_nodes_in_group(group_name).filter(func(node):
		return is_node_valid(node)
	)
