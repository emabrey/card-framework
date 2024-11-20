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
@export var card_ui_face_up := true

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
	drop_zone.card_dropped.connect(_card_dropped)
	drop_zone.set_sensor(sensor_size, sensor_position, sensor_color, sensor_visibility)
	drop_zone.set_placement(placement_size, placement_position, placement_color, placement_visibility)
	

func _card_dropped(card: Card) -> void:
	add_card(card)
	

func add_card(card: Card) -> void:
	var global_pos = card.global_position
	card.get_parent().remove_child(card)
	cards.add_child(card)
	card.global_position = global_pos
