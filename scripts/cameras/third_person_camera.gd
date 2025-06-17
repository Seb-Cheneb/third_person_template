class_name ThirdPersonCamera 
extends Node


@export_range(0, 100, 1) 
var spring_arm_length: float = 5

@export_range(0, 1, 0.00025) 
var mouse_sensitivity: float = 0.00075

@export_range(-360, 360, 10, "degrees") 
var min_boundary: float = -60:
	set(value):
		min_boundary = deg_to_rad(value)
		
@export_range(-360, 360, 10, "degrees") 
var max_boundary: float = 10:
	set(value):
		max_boundary = deg_to_rad(value)

var _look: Vector2 = Vector2.ZERO # stores the x / y direction the player is trying to look in

@onready var horizontal_pivot: Node3D = $HorizontalPivot
@onready var vertical_pivot: Node3D = $HorizontalPivot/VerticalPivot
@onready var spring_arm: SpringArm3D = $SpringArm3D


func _ready() -> void:
	spring_arm.spring_length = spring_arm_length


func _physics_process(delta: float) -> void:
	horizontal_pivot.rotate_y(_look.x)
	vertical_pivot.rotate_x(_look.y)
	vertical_pivot.rotation.x = clampf(vertical_pivot.rotation.x, min_boundary, max_boundary)
	spring_arm.global_transform = vertical_pivot.global_transform
	_look = Vector2.ZERO
	
	
func _unhandled_input(event: InputEvent) -> void:
	# only works if the mouse isn't seen (captured)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			_look = -event.relative * mouse_sensitivity



	
