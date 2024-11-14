class_name DropZone
extends Control

static var next_id = 0
var unique_id: int
var enabled := true

func _init():
	unique_id = next_id
	next_id += 1
	
	
func _ready():
	CardFrameworkSignalBus.drop_zone_added.emit(unique_id, self)


func _exit_tree() -> void:
	CardFrameworkSignalBus.drop_zone_deleted.emit(unique_id)


func _check_mouse_is_in_drop_zone() -> bool:
	var mouse_position = get_global_mouse_position()
	return get_global_rect().has_point(mouse_position)


func set_enabled(_enabled: bool):
	enabled = _enabled
	if enabled:
		CardFrameworkSignalBus.drop_zone_enabled.emit(unique_id)
	else:
		CardFrameworkSignalBus.drop_zone_disabled.emit(unique_id)

func check_card_can_be_dropped(card: Card):
	return _check_mouse_is_in_drop_zone()
