extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var _camera_component: ThirdPersonCamera
@export var _animation_decay: float = 20.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity") # default gravity of the engine

@onready var rig_pivot: Node3D = $RigPivot


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	_camera_component.on_physics_process()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var direction := get_movement_direction()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		look_toward_direction(direction, delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_camera_component.on_unhandled_input(event)


func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
	var direction := _camera_component.horizontal_pivot.global_transform.basis * input_vector
	return direction


func look_toward_direction(direction: Vector3, delta: float) -> void:
	var target_transform := rig_pivot.global_transform.looking_at(rig_pivot.global_position + direction, Vector3.UP, true)
	rig_pivot.global_transform = rig_pivot.global_transform.interpolate_with(target_transform, 1.0 - exp(-_animation_decay * delta))
	
