extends Node

signal drop_zone_added(zone_id: int, zone_node: DropZone)
signal drop_zone_deleted(zone_id: int)

signal drag_dropped(card: Card)
signal card_dropped(card: Card, drop_zone: DropZone)
signal card_move_done(card: Card)


func _ready():
	drop_zone_added.connect(_on_drop_zone_added)
	drop_zone_deleted.connect(_on_drop_zone_deleted)
	drag_dropped.connect(_on_drag_dropped)
	card_dropped.connect(_on_card_dropped)
	card_move_done.connect(_on_card_move_done)
	
func _on_drop_zone_added(_zone_id: int, _zone_node: DropZone):
	pass

func _on_drop_zone_deleted(_zone_id: int):
	pass

func _on_drag_dropped(_card: Card):
	pass

func _on_card_dropped(_card: Card, _drop_zone: DropZone):
	pass

func _on_card_move_done(_card: Card):
	pass
