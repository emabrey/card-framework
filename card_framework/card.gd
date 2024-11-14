class_name Card
extends Control

signal card_picked(card: Card)
signal card_dropped(card: Card)

var is_hovering := false
var is_clicked := false
var is_holding := false
var current_holding_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():	
	mouse_filter = Control.MOUSE_FILTER_STOP
	connect("mouse_entered", _on_mouse_enter)
	connect("mouse_exited", _on_mouse_exited)
	connect("gui_input", _on_gui_input)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_holding:
		position = get_global_mouse_position() - current_holding_position
	
func _on_mouse_enter():
	if _can_interact_with():
		is_hovering = true
	
func _on_mouse_exited():
	if _can_interact_with():
		is_hovering = false

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return
		
		if mouse_event.pressed:
			is_clicked = true
			is_holding = true
			current_holding_position = get_local_mouse_position()
		else:
			if is_holding:
				CardFrameworkSignalBus.card_dropped.emit(self)
			is_clicked = false
			is_holding = false

func _can_interact_with() -> bool:
	return true
