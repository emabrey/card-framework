class_name CardContainer
extends Control

static var next_id = 0

@export_group("drop_zone")
@export var enable_drop_zone := true
@export_subgroup("Sensor")
##The size of the sensor. If not set, it will follow the size of the card.
@export var sensor_size: Vector2
@export var sensor_position: Vector2
@export var sensor_texture: Texture
@export var sensor_visibility := true

@export_subgroup("Placement")
##The size of the placement. If not set, it will follow the size of the card.
@export var placement_size: Vector2
@export var placement_position: Vector2
@export var placement_texture: Texture
@export var placement_visibility := true


var unique_id: int
var _held_cards := []
var _holding_cards := []
var drop_zone_scene = preload("drop_zone.tscn")
var drop_zone = null

var cards_node: Control
var card_manager: CardManager


func _init():
	unique_id = next_id
	next_id += 1


func _ready() -> void:
	CardFrameworkSignalBus.card_container_added.emit(unique_id, self)
	
	# Check if 'Cards' node already exists
	if has_node("Cards"):
		cards_node = $Cards
	else:
		cards_node = Control.new()
		cards_node.name = "Cards"
		cards_node.mouse_filter = Control.MOUSE_FILTER_STOP
		add_child(cards_node)
	
	if enable_drop_zone:
		drop_zone = drop_zone_scene.instantiate()
		add_child(drop_zone)
		drop_zone.parent_card_container = self
		# If sensor_size and placement_size are not set, they will follow the card size.
		if sensor_size == Vector2(0, 0):
			sensor_size = card_manager.card_size
		if placement_size == Vector2(0, 0):
			placement_size = card_manager.card_size
		drop_zone.set_sensor(sensor_size, sensor_position, sensor_texture, sensor_visibility)
		drop_zone.set_placement(placement_size, placement_position, placement_texture, placement_visibility)


func _exit_tree() -> void:
	CardFrameworkSignalBus.card_container_deleted.emit(unique_id)


func update_card_positions(card: Card) -> void:
	card.card_container = self
	if not _held_cards.has(card):
		_held_cards.append(card)
	_update_target_z_index()
	_update_target_positions()


func add_card(card: Card) -> void:
	update_card_positions(card)
	_move_object(card, cards_node)


func remove_card(card: Card) -> bool:
	var index = _held_cards.find(card)
	if index != -1:
		_held_cards.remove_at(_held_cards.find(card))
	_update_target_z_index()
	_update_target_positions()
	return true


func has_card(card: Card) -> bool:
	var index = _held_cards.find(card)
	return index != -1


func clear_cards():
	for card in _held_cards:
		_remove_object(card)
	_held_cards.clear()


func check_card_can_be_dropped(cards: Array) -> bool:
	if not drop_zone.check_mouse_is_in_drop_zone():
		return false
	return _card_can_be_added(cards)


func _move_cards(cards: Array):
	for i in range(cards.size() - 1, -1, -1):
		var card = cards[i]
		_move_to_card_container(card)


func move_cards(cards: Array, with_history: bool = true):
	if with_history:
		card_manager.add_history(self, cards)
	_move_cards(cards)


func undo(cards: Array):
	_move_cards(cards)


func _move_to_card_container(_card: Card):
	_card.card_container.remove_card(_card)
	add_card(_card)
	_card.target_container = self


func hold_card(card: Card):
	_holding_cards.append(card)


func release_holding_cards():
	if _holding_cards.size() == 0:
		return
	for card in _holding_cards:
		card.set_releasing()
	var copied_holding_cards = _holding_cards.duplicate()
	CardFrameworkSignalBus.drag_dropped.emit(copied_holding_cards)
	_holding_cards.clear()
	
func get_string() -> String:
	return "card_container: %d" % unique_id


func _card_can_be_added(_cards: Array) -> bool:
	return true


func _update_target_z_index():
	pass


func _update_target_positions():
	pass


func _move_object(target: Node, to: Node):
	if target.get_parent() != null:
		var global_pos = target.global_position
		target.get_parent().remove_child(target)
		to.add_child(target)
		target.global_position = global_pos
	else:
		to.add_child(target)

func _remove_object(target: Node):
	if target.get_parent() != null:
		target.get_parent().remove_child(target)
	target.queue_free()
