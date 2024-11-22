extends Node

static func move_object(target: Node, to: Node):
	var global_pos = target.global_position
	target.get_parent().remove_child(target)
	to.add_child(target)
	target.global_position = global_pos
