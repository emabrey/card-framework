class_name CardContainer
extends Control

@export_group("drop_zone")
@export var enable_drop_zone := true
@export_subgroup("Sensor")
##The size of the sensor. If not set, it will follow the size of the card.
@export var sensor_size: Vector2
@export var sensor_position: Vector2
@export var sensor_color := Color(0.0, 0.0, 0.0, 0.0)
@export var sensor_visibility := true

@export_subgroup("Placement")
##The size of the placement. If not set, it will follow the size of the card.
@export var placement_size: Vector2
@export var placement_position: Vector2
@export var placement_color := Color(0.0, 0.0, 0.0, 0.0)
@export var placement_visibility := true


var _held_cards := []
var drop_zone_scene = preload("drop_zone.tscn")
var drop_zone = null
var cards


func _ready() -> void:
	# Check if 'Cards' node already exists
	if has_node("Cards"):
		cards = $Cards
	else:
		cards = Control.new()
		cards.name = "Cards"
		cards.mouse_filter = Control.MOUSE_FILTER_STOP
		add_child(cards)
	
	CardFrameworkSignalBus.card_dropped.connect(_card_dropped)
	if enable_drop_zone:
		drop_zone = drop_zone_scene.instantiate()
		add_child(drop_zone)
		# If sensor_size and placement_size are not set, they will follow the card size.
		if is_instance_valid(get_parent()) and get_parent() is CardManager:
			var card_manager = get_parent() as CardManager
			if sensor_size == Vector2(0, 0):
				sensor_size = card_manager.card_size
			if placement_size == Vector2(0, 0):
				placement_size = card_manager.card_size
		drop_zone.set_sensor(sensor_size, sensor_position, sensor_color, sensor_visibility)
		drop_zone.set_placement(placement_size, placement_position, placement_color, placement_visibility)


func _card_dropped(card: Card, target_drop_zone: DropZone) -> void:
	if enable_drop_zone and self.drop_zone == target_drop_zone:
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



func card_can_be_added(_card: Card) -> bool:
	return true


func _update_target_positions():
	pass
