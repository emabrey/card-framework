class_name CardContainer
extends Control

@export_group("drop_zone")
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

@onready var cards := $Cards
@onready var drop_zone := $DropZone


func _ready() -> void:
	CardFrameworkSignalBus.card_dropped.connect(_card_dropped)
	drop_zone.set_sensor(sensor_size, sensor_position, sensor_color, sensor_visibility)
	drop_zone.set_placement(placement_size, placement_position, placement_color, placement_visibility)


func _card_dropped(card: Card, drop_zone: DropZone) -> void:
	if self.drop_zone == drop_zone:
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


func _update_target_positions():
	pass
