extends Node

signal drag_dropped(cards: Array)
signal card_move_done(card: Card)


func _ready():
	drag_dropped.connect(_on_drag_dropped)
	card_move_done.connect(_on_card_move_done)

func _on_drag_dropped(_cards: Array):
	pass

func _on_card_move_done(_card: Card):
	pass