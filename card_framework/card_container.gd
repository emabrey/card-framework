class_name CardContainer
extends Control

@export_group("drop_zone")
@export var enable_drop_zone := true
@export_subgroup("Sensor")
@export var sensor_size: Vector2
@export var sensor_position: Vector2
@export var sensor_color := Color(0.0, 0.0, 0.0, 0.0)
@export var sensor_visibility := true

@export_subgroup("Placement")
@export var placement_size: Vector2
@export var placement_position: Vector2
@export var placement_color := Color(0.0, 0.0, 0.0, 0.0)
@export var placement_visibility := true

var _held_cards := []
var drop_zone_scene = preload("drop_zone.tscn")
var drop_zone = null

@onready var cards := $Cards


func _ready() -> void:
	CardFrameworkSignalBus.card_dropped.connect(_card_dropped)
	if enable_drop_zone:
		drop_zone = drop_zone_scene.instantiate()
		add_child(drop_zone)
		drop_zone.set_sensor(sensor_size, sensor_position, sensor_color, sensor_visibility)
		drop_zone.set_placement(placement_size, placement_position, placement_color, placement_visibility)


func _card_dropped(card: Card, drop_zone: DropZone) -> void:
	if enable_drop_zone and self.drop_zone == drop_zone:
		if !_held_cards.has(card):
			add_card(card)
		else:
			_update_target_positions()
	elif _held_cards.has(card):
		remove_card(card)


func add_card(card: Card) -> void:
	Util.move_object(card, cards)
	_held_cards.append(card)
	_update_target_positions()


func remove_card(card: Card) -> bool:
	var index = _held_cards.find(card);
	if index == -1:
		return false
	_held_cards.remove_at(_held_cards.find(card))
	_update_target_positions()
	return true



func card_can_be_added(card: Card) -> bool:
	return true


func _update_target_positions():
	pass
