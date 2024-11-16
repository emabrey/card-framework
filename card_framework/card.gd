class_name Card
extends Control

const HOLDING_Z_INDEX = 1000

@export var card_size := Vector2(150, 210)
@export var front_image: Texture2D
@export var back_image: Texture2D
@export var show_front := true : 
	set(value):
		if value:
			front_face_texture.visible = true
			back_face_texture.visible = false
		else:
			front_face_texture.visible = false
			back_face_texture.visible = true

@export var return_speed := 2000

var is_hovering := false
var is_clicked := false
var is_holding := false
var stored_z_index: int
var is_moving_to_destination := false
var current_holding_mouse_position: Vector2
var destination: Vector2

@onready var front_face_texture := $FrontFace/TextureRect
@onready var back_face_texture := $BackFace/TextureRect

func _ready():	
	mouse_filter = Control.MOUSE_FILTER_STOP
	connect("mouse_entered", _on_mouse_enter)
	connect("mouse_exited", _on_mouse_exited)
	connect("gui_input", _on_gui_input)
	
	front_face_texture.size = card_size
	back_face_texture.size = card_size
	if front_image:
		front_face_texture.texture = front_image
	if back_image:
		back_face_texture.texture = back_image
		
	destination = position
	show_front = show_front
	stored_z_index = z_index


func _process(delta):
	if is_holding:
		position = get_global_mouse_position() - current_holding_mouse_position
		
	if is_moving_to_destination:
		position = position.move_toward(destination, return_speed * delta)
		if position == destination:
			is_moving_to_destination = false
			mouse_filter = Control.MOUSE_FILTER_STOP
			z_index = stored_z_index


func return_card():
	is_moving_to_destination = true
	
	
func move_to_drop_zone(drop_zone: DropZone):
	is_moving_to_destination = true
	destination = drop_zone.placement_position
	
	
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
			current_holding_mouse_position = get_local_mouse_position()
			z_index = HOLDING_Z_INDEX
		else:
			if is_holding:
				CardFrameworkSignalBus.drag_dropped.emit(self)
				mouse_filter = Control.MOUSE_FILTER_IGNORE
			is_clicked = false
			is_holding = false


func _can_interact_with() -> bool:
	return true
