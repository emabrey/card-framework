class_name DropZone
extends Control

var sensor_size: Vector2 : 
	set(value):
		sensor.size = value
var sensor_position: Vector2 : 
	set(value):
		sensor.position = value
var sensor_texture : Texture :
	set(value):
		sensor_holder.texture = value
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
		placement_holder.texture = value
var placement_visible := true :
	set(value):
		placement.visible = value

var stored_sensor_position: Vector2
var stored_placement_position: Vector2
var parent_card_container: CardContainer

var sensor: Control
var placement: Control
var sensor_holder: Control
var placement_holder: Control

func check_mouse_is_in_drop_zone() -> bool:
	var mouse_position = get_global_mouse_position()
	var result = sensor.get_global_rect().has_point(mouse_position)
	return result


func set_sensor(_size: Vector2, _positon: Vector2, _texture: Texture, _visible: bool):
	if sensor == null:
		sensor = TextureRect.new()
		sensor.name = "Sensor"
		sensor.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sensor.z_index = -1000
		add_child(sensor)
		
	if sensor_holder == null:
		sensor_holder = TextureRect.new()
		sensor_holder.name = "SensorHolder"
		sensor_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
		sensor_holder.z_index = -1000
		add_child(sensor_holder)
		sensor_holder.size = _size
		sensor_holder.position = _positon
		sensor_holder.texture = _texture
		sensor_holder.visible = _visible
		
	sensor_size = _size
	sensor_position = _positon
	stored_sensor_position = _positon
	sensor_visible = _visible

func set_placement(_size: Vector2, _positon: Vector2, _texture: Texture, _visible: bool):
	if placement == null:
		placement = TextureRect.new()
		placement.name = "Placement"
		placement.mouse_filter = Control.MOUSE_FILTER_IGNORE
		placement.z_index = -1000
		add_child(placement)
		
	if placement_holder == null:
		placement_holder = TextureRect.new()
		placement_holder.name = "SensorHolder"
		placement_holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
		placement_holder.z_index = -1000
		add_child(placement_holder)
		placement_holder.size = _size
		placement_holder.position = _positon
		placement_holder.texture = _texture
		placement_holder.visible = _visible
		
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
