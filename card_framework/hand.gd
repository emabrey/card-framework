class_name Hand
extends Control

@export var hand_area: Vector2
@export var drop_zone: DropZone

@export_group("hand_meta_info")
@export var max_hand_size := 10
@export var max_hand_spread := 700
@export var card_ui_hover_distance := 30

@export_group("hand_shape")
## This works best as a 2-point linear rise from -X to +X
@export var hand_rotation_curve : Curve
## This works best as a 3-point ease in/out from 0 to X to 0
@export var hand_vertical_curve : Curve

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

func _ready():
	size = hand_area


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
