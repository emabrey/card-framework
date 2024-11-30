extends Node

func move_object(target: Node, to: Node):
	if target.get_parent() != null:
		var global_pos = target.global_position
		target.get_parent().remove_child(target)
		to.add_child(target)
		target.global_position = global_pos
	else:
		to.add_child(target)
