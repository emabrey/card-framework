class_name DropZone
extends Control

static var next_id = 0

var sensor_size: Vector2 : 
	set(value):
		sensor.size = value
var sensor_position: Vector2 : 
	set(value):
		sensor.position = value
var sensor_texture : Texture :
	set(value):
		sensor.texture = value
var sensor_visible := true :
	set(value):
		sensor.visible = value
var placement_size: Vector2 : 
	set(value):
		placement.size = value
var placement_position: Vector2 : 
	set(value):
		placement.position = value
var placement_texture : Texture :
	set(value):
		placement.texture = value
var placement_visible := true :
	set(value):
		placement.visible = value

var stored_sensor_position: Vector2
var stored_placement_position: Vector2

var unique_id: int
var enabled := true
var parent_card_container: CardContainer = null

var sensor: Control
var placement: Control

func _init():
	unique_id = next_id
	next_id += 1
	
	
func _ready():
	if is_instance_valid(get_parent()) and get_parent() is CardContainer:
		parent_card_container = get_parent() as CardContainer
	CardFrameworkSignalBus.drop_zone_added.emit(unique_id, self)


func _exit_tree() -> void:
	CardFrameworkSignalBus.drop_zone_deleted.emit(unique_id)


func _check_mouse_is_in_drop_zone() -> bool:
	var mouse_position = get_global_mouse_position()
	var result = sensor.get_global_rect().has_point(mouse_position)
	return result


func set_enabled(_enabled: bool):
	enabled = _enabled
	if enabled:
		CardFrameworkSignalBus.drop_zone_enabled.emit(unique_id)
	else:
		CardFrameworkSignalBus.drop_zone_disabled.emit(unique_id)


func check_card_can_be_dropped(card: Card):
	if parent_card_container != null and not _check_mouse_is_in_drop_zone():
		return false
	return parent_card_container.card_can_be_added(card)


func set_sensor(_size: Vector2, _positon: Vector2, _texture: Texture, _visible: bool):
	if sensor == null:
		sensor = TextureRect.new()
		sensor.name = "Sensor"
		sensor.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sensor.z_index = -1000
		add_child(sensor)
	sensor_size = _size
	sensor_position = _positon
	stored_sensor_position = _positon
	sensor_texture = _texture
	sensor_visible = _visible
	

func set_placement(_size: Vector2, _positon: Vector2, _texture: Texture, _visible: bool):
	if placement == null:
		placement = TextureRect.new()
		placement.name = "Placement"
		placement.mouse_filter = Control.MOUSE_FILTER_IGNORE
		placement.z_index = -1000
		add_child(placement)
	placement_size = _size
	placement_position = _positon
	stored_placement_position = _positon
	placement_texture = _texture
	placement_visible = _visible


func change_sensor_position_with_offset(offset: Vector2):
	sensor_position = stored_sensor_position + offset


func change_placement_position_with_offset(offset: Vector2):
	placement_position = stored_placement_position + offset


func get_place_zone() -> Vector2:
	return placement.global_position
