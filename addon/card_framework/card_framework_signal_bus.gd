extends Node

signal drag_dropped(cards: Array)
signal card_move_done(card: Card)

signal card_clicked(card: Card)
signal card_released(card: Card)


func _ready():
	drag_dropped.connect(_on_drag_dropped)
	card_move_done.connect(_on_card_move_done)
	card_clicked.connect(_on_card_clicked)
	card_released.connect(_on_card_released)

func _on_drag_dropped(_cards: Array):
	pass

func _on_card_move_done(_card: Card):
	pass

func _on_card_clicked(_card: Card):
	pass

func _on_card_released(_card: Card):
	pass
