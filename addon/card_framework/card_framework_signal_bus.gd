extends Node

signal drag_dropped(cards: Array)


func _ready():
	drag_dropped.connect(_on_drag_dropped)

func _on_drag_dropped(_cards: Array):
	pass
