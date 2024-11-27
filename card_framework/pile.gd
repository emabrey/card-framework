class_name Pile
extends CardContainer

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
@export var align_drop_zone_with_top_card := true

func get_top_card() -> Card:
	return _held_cards.back()


func shuffle():
	_held_cards.shuffle()
	for i in _held_cards.size():
		var card = _held_cards[i]
		cards.move_child(card, i)
	_update_target_positions()


func _update_target_positions():
	var last_offset: Vector2
	for i in _held_cards.size():
		var card = _held_cards[i]
		var offset = _calculate_offset(i)
		last_offset = offset
		var target_pos = position + offset
		card.show_front = card_face_up
		card.stored_z_index = 3000 + i if card.is_clicked else i
		card.move_rotation(0)
		card.move(target_pos)
		
		if set_top_accessible_only:
			if i == _held_cards.size() - 1:
				card.can_be_interact_with = true
			else:
				card.can_be_interact_with = false
	
	if enable_drop_zone and align_drop_zone_with_top_card:
		drop_zone.change_sensor_position_with_offset(last_offset)


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
