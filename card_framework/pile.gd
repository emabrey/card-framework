class_name Pile
extends Control

enum PileDirection {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

@export var stack_display_gap := 8
@export var max_stack_display := 6
@export var card_face_up := true
@export var layout := PileDirection.UP
@export var set_top_accessible_only := true

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


func get_top_card() -> Card:
	return _held_cards.back()


func shuffle():
	_held_cards.shuffle()
	for i in _held_cards.size():
		var card = _held_cards[i]
		cards.move_child(card, i)
	_update_target_positions()


func _update_target_positions():
	for i in _held_cards.size():
		var card = _held_cards[i]
		var target_pos = position + _calculate_offset(i)
		card.show_front = card_face_up
		card.stored_z_index = 3000 + i if card.is_clicked else i
		card.move_rotation(0)
		card.move(target_pos)
		
		if set_top_accessible_only:
			if i == _held_cards.size() - 1:
				card.can_be_interact_with = true
			else:
				card.can_be_interact_with = false


func _calculate_offset(index: int) -> Vector2:
	var offset = Vector2()
	var actual_index = min(index, max_stack_display - 1)
	var offset_value = actual_index * stack_display_gap

	match layout:
		PileDirection.UP:
			offset.y -= offset_value
		PileDirection.DOWN:
			offset.y += offset_value
		PileDirection.RIGHT:
			offset.x += offset_value
		PileDirection.LEFT:
			offset.x -= offset_value

	return offset
