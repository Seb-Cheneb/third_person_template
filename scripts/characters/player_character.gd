class_name PlayerCharacter
extends Character

@export var camera_component: ThirdPersonCamera

# Raw input data that states can use
var input_direction: Vector2 = Vector2.ZERO
var previous_input_direction: Vector2 = Vector2.ZERO
var input_changed: bool = false

func _physics_process(delta: float) -> void:
	update_input()
	super._physics_process(delta)

func update_input() -> void:
	var current_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	input_changed = not current_input.is_equal_approx(previous_input_direction)
	if input_changed:
		input_direction = current_input
		previous_input_direction = current_input
