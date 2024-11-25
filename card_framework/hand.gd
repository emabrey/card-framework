class_name Hand
extends Control

@export var hand_area: Vector2

@export_group("hand_meta_info")
@export var max_hand_size := 10
@export var max_hand_spread := 700
@export var card_face_up := true
@export var card_hover_distance := 30

@export_group("hand_shape")
## This works best as a 2-point linear rise from -X to +X
@export var hand_rotation_curve : Curve
## This works best as a 3-point ease in/out from 0 to X to 0
@export var hand_vertical_curve : Curve

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
	size = hand_area


func _card_dropped(card: Card, drop_zone: DropZone) -> void:
	if self.drop_zone == drop_zone:
		if !_held_cards.has(card):
			add_card(card)
		_update_target_positions()
	elif _held_cards.has(card):
		remove_card(card)


func add_card(card: Card) -> void:
	Util.move_object(card, cards)
	_held_cards.append(card)


func remove_card(card: Card) -> bool:
	var index = _held_cards.find(card);
	if index == -1:
		return false
	_held_cards.remove_at(_held_cards.find(card))
	_update_target_positions()
	return true


func _update_target_positions():
	for i in _held_cards.size():
		var card = _held_cards[i]
		var hand_ratio = 0.5
		if _held_cards.size() > 1:
			hand_ratio = float(i) / float(_held_cards.size() - 1)
		var target_pos = global_position
		var card_spacing = max_hand_spread / (_held_cards.size() + 1)
		target_pos.x += (i + 1) * card_spacing - max_hand_spread / 2.0
		if hand_vertical_curve:
			target_pos.y -= hand_vertical_curve.sample(hand_ratio)
		if hand_rotation_curve:
			card.move_rotation(deg_to_rad(hand_rotation_curve.sample(hand_ratio)))
		card.move(target_pos)
		card.show_front = card_face_up
