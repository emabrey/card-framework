class_name DropZone
extends Control

static var next_id = 0

@export_group("Sensor")
@export var sensor_size: Vector2
@export var sensor_position: Vector2
@export var sensor_color := Color(0.0, 0.0, 0.0, 0.0)
@export var sensor_visibility := true

@export_group("Placement")
@export var placement_size: Vector2
@export var placement_position: Vector2
@export var placement_color := Color(0.0, 0.0, 0.0, 0.0)
@export var placement_visibility := true

var unique_id: int
var enabled := true

@onready var sensor := $Sensor
@onready var placement := $Placement

func _init():
	unique_id = next_id
	next_id += 1
	
	
func _ready():
	CardFrameworkSignalBus.drop_zone_added.emit(unique_id, self)
	set_sensor(sensor_size, sensor_position, sensor_color, sensor_visibility)
	set_placement(placement_size, placement_position, placement_color, placement_visibility)


func _exit_tree() -> void:
	CardFrameworkSignalBus.drop_zone_deleted.emit(unique_id)


func _check_mouse_is_in_drop_zone() -> bool:
	var mouse_position = get_global_mouse_position()
	return sensor.get_global_rect().has_point(mouse_position)


func set_enabled(_enabled: bool):
	enabled = _enabled
	if enabled:
		CardFrameworkSignalBus.drop_zone_enabled.emit(unique_id)
	else:
		CardFrameworkSignalBus.drop_zone_disabled.emit(unique_id)


func check_card_can_be_dropped(card: Card):
	return _check_mouse_is_in_drop_zone()


func set_sensor(size: Vector2, positon: Vector2, color: Color, visible: bool):
	sensor.size = size
	sensor.position = position
	sensor.color = color
	sensor.visible = visible
	

func set_placement(size: Vector2, positon: Vector2, color: Color, visible: bool):
	placement.size = size
	placement.position = position
	placement.color = color
	placement.visible = visible


func get_place_zone() -> Vector2:
	return placement.global_position
