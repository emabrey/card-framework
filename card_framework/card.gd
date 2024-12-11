class_name Card
extends Control

const HOLDING_Z_INDEX = 1000

@export var card_name: String
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

@export var return_speed := 200
@export var can_be_interact_with := true
@export var hover_distance := 10

var card_info: Dictionary

var is_hovering := false
var is_clicked := false
var is_holding := false
var stored_z_index: int :
	set(value):
		z_index = value
		stored_z_index = value
var is_moving_to_destination := false
var current_holding_mouse_position: Vector2
var destination: Vector2
var destination_as_local: Vector2
var destination_degree: float
var target_container: CardContainer
var card_container: CardContainer
var is_destination_set := true

static var hovering_card_count := 0

@onready var front_face_texture := $FrontFace/TextureRect
@onready var back_face_texture := $BackFace/TextureRect


func _ready():	
	mouse_filter = Control.MOUSE_FILTER_STOP
	connect("mouse_entered", _on_mouse_enter)
	connect("mouse_exited", _on_mouse_exited)
	connect("gui_input", _on_gui_input)
	
	CardFrameworkSignalBus.drag_dropped.connect(_on_drag_dropped)
	CardFrameworkSignalBus.card_move_done.connect(_on_card_move_done)
	
	front_face_texture.size = card_size
	back_face_texture.size = card_size
	if front_image:
		front_face_texture.texture = front_image
	if back_image:
		back_face_texture.texture = back_image
	pivot_offset = card_size / 2
	destination = global_position
	show_front = show_front
	stored_z_index = z_index

func _process(delta):
	if is_holding:
		start_hovering()
		global_position = get_global_mouse_position() - current_holding_mouse_position
		
	if is_moving_to_destination:
		if is_destination_set:
			_set_destination()
			is_destination_set = false

		var new_position = position.move_toward(destination_as_local, return_speed * delta)

		if position == new_position or position.distance_to(destination_as_local) < 0.01:
			position = destination_as_local
			is_moving_to_destination = false
			end_hovering(false)
			z_index = stored_z_index
			CardFrameworkSignalBus.card_move_done.emit(self)
			is_destination_set = true
			if target_container != null:
				target_container = null
		else:
			position = new_position


func set_faces(front_face: Texture2D, back_face: Texture2D):
	front_face_texture.texture = front_face
	back_face_texture.texture = back_face
	

func return_card():
	rotation = 0
	is_moving_to_destination = true


func move(target_destination: Vector2):
	rotation = 0
	is_moving_to_destination = true
	self.destination = target_destination


func move_rotation(degree: float):
	destination_degree = degree


func start_hovering():
	if not is_hovering:
		is_hovering = true
		hovering_card_count += 1
		z_index = stored_z_index + HOLDING_Z_INDEX
		position.y -= hover_distance


func end_hovering(restore_card_position: bool):
	if is_hovering:
		z_index = stored_z_index
		is_hovering = false
		hovering_card_count -= 1
		if hovering_card_count < 0:
			hovering_card_count = 0
		if restore_card_position:
			position.y += hover_distance


func set_holding():
	is_holding = true
	current_holding_mouse_position = get_local_mouse_position()
	z_index = stored_z_index + HOLDING_Z_INDEX
	rotation = 0
	if card_container != null:
		card_container.hold_card(self)


func set_releasing():
	is_holding = false


func get_string():
	return card_name


func _on_mouse_enter():
	if hovering_card_count == 0 and !is_moving_to_destination and can_be_interact_with:
		start_hovering()


func _on_mouse_exited():
	if is_clicked:
		return
	end_hovering(true)


func _on_gui_input(event: InputEvent):
	if !can_be_interact_with:
		return false
		
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index != MOUSE_BUTTON_LEFT:
			return
		
		if mouse_event.is_pressed():
			is_clicked = true
			CardFrameworkSignalBus.card_clicked.emit(self)
			set_holding()
		
		if mouse_event.is_released():
			is_clicked = false
			CardFrameworkSignalBus.card_released.emit(self)
			if card_container != null:
				card_container.release_holding_cards()


func _set_destination():
	var t = get_global_transform().affine_inverse()
	var local_position = (t.x * destination.x) + (t.y * destination.y) + t.origin
	destination_as_local = local_position + position
	rotation = destination_degree
	z_index = stored_z_index + HOLDING_Z_INDEX


func _on_drag_dropped(_cards: Array):
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_card_move_done(_card: Card):
	mouse_filter = Control.MOUSE_FILTER_STOP