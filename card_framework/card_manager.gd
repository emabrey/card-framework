class_name CardManager
extends Control

@export var card_size := Vector2(150, 210)

var drop_zone_dict := {}

@onready var card_factory := $CardFactory

func _init() -> void:
	CardFrameworkSignalBus.drop_zone_added.connect(_on_drop_zone_added)
	CardFrameworkSignalBus.drop_zone_deleted.connect(_on_drop_zone_deleted)
	CardFrameworkSignalBus.drag_dropped.connect(_on_card_dropped)


func _ready() -> void:
	card_factory.card_size = card_size


func _on_drop_zone_added(id: int, drop_zone: DropZone):
	drop_zone_dict[id] = drop_zone


func _on_drop_zone_deleted(id: int):
	drop_zone_dict.erase(id)


func _on_card_dropped(card: Card) -> DropZone:
	for key in drop_zone_dict.keys():
		var drop_zone = drop_zone_dict[key]
		if drop_zone.enabled:
			var result = drop_zone.check_card_can_be_dropped(card)
			if result:
				card.move_to_drop_zone(drop_zone)
				return drop_zone
				
	card.return_card()
	return null


# XXX: Temp code
func _on_card_create_button_pressed() -> void:
	var card_factory := $CardFactory
	var hand := $Hand
	card_factory.create_card("diamond_2", hand)
