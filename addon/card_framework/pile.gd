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
##Determines whether any card in the pile can be moved
@export var allow_card_movement: bool = true
##Restricts movement to only the top card of the pile (requires allow_card_movement to be true)
@export var restrict_to_top_card: bool = true
@export var align_drop_zone_with_top_card := true

const PILE_Z_INDEX := 3000


func get_top_cards(n: int) -> Array:
	var arr_size = _held_cards.size()
	if n > arr_size:
		n = arr_size
	
	var result = []
	
	for i in range(n):
		result.append(_held_cards[arr_size - 1 - i])
	
	return result


func _update_target_z_index():
	for i in range(_held_cards.size()):
		var card = _held_cards[i]
		card.stored_z_index = PILE_Z_INDEX + i if card.is_clicked else i


func _update_target_positions():
	var last_index = _held_cards.size() - 1
	var last_offset = _calculate_offset(last_index)
	if enable_drop_zone and align_drop_zone_with_top_card:
		drop_zone.change_sensor_position_with_offset(last_offset)

	for i in range(_held_cards.size()):
		var card = _held_cards[i]
		var offset = _calculate_offset(i)
		var target_pos = position + offset
		card.show_front = card_face_up
		card.move(target_pos, 0)
		
		if not allow_card_movement: 
			card.can_be_interact_with = false
		elif restrict_to_top_card:
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
