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
var cards_node


func _init():
	unique_id = next_id
	next_id += 1


func _ready() -> void:
	# Check if 'Cards' node already exists
	if has_node("Cards"):
		cards_node = $Cards
	else:
		cards_node = Control.new()
		cards_node.name = "Cards"
		cards_node.mouse_filter = Control.MOUSE_FILTER_STOP
		add_child(cards_node)
	
	CardFrameworkSignalBus.card_dropped.connect(_card_dropped)
	if enable_drop_zone:
		drop_zone = drop_zone_scene.instantiate()
		add_child(drop_zone)
		drop_zone.parent_card_container = self
		# If sensor_size and placement_size are not set, they will follow the card size.
		if is_instance_valid(get_parent()) and get_parent() is CardManager:
			var card_manager = get_parent() as CardManager
			if sensor_size == Vector2(0, 0):
				sensor_size = card_manager.card_size
			if placement_size == Vector2(0, 0):
				placement_size = card_manager.card_size
		drop_zone.set_sensor(sensor_size, sensor_position, sensor_texture, sensor_visibility)
		drop_zone.set_placement(placement_size, placement_position, placement_texture, placement_visibility)
	CardFrameworkSignalBus.card_container_added.emit(unique_id, self)


func _exit_tree() -> void:
	CardFrameworkSignalBus.card_container_deleted.emit(unique_id)


func _card_dropped(card: Card, target: CardContainer) -> void:
	if enable_drop_zone and target == self:
		if !_held_cards.has(card):
			add_card(card)
		else:
			_update_target_z_index()
			_update_target_positions()
	elif _held_cards.has(card):
		remove_card(card)


func update_card_positions(card: Card) -> void:
	card.card_container = self
	if not _held_cards.has(card):
		_held_cards.append(card)
	_update_target_z_index()
	_update_target_positions()


func add_card(card: Card) -> void:
	update_card_positions(card)
	Util.move_object(card, cards_node)


func remove_card(card: Card) -> bool:
	var index = _held_cards.find(card)
	if index == -1:
		return false
	_held_cards.remove_at(_held_cards.find(card))
	_update_target_z_index()
	_update_target_positions()
	return true


func has_card(card: Card) -> bool:
	var index = _held_cards.find(card)
	return index != -1


func clear_cards():
	for card in _held_cards:
		Util.remove_object(card)
	_held_cards.clear()


func check_card_can_be_dropped(cards: Array) -> bool:
	if not drop_zone.check_mouse_is_in_drop_zone():
		return false
	return _card_can_be_added(cards)


func move_cards(cards: Array):
	for card in cards:
		card.move_to_card_container(self)


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


func _card_can_be_added(_cards: Array) -> bool:
	return true


func _update_target_z_index():
	pass


func _update_target_positions():
	pass
