class_name PlayerCharacter
extends Character

@export var camera_component: ThirdPersonCamera

# Cache the previous input to detect changes and avoid unnecessary calculations
var previous_input_direction: Vector2 = Vector2.ZERO
var movement_direction_dirty: bool = false

func _physics_process(delta: float) -> void:
	update_movement_direction()
	super._physics_process(delta)

func update_movement_direction() -> void:
	var current_input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Only recalculate if input changed
	if not current_input.is_equal_approx(previous_input_direction):
		previous_input_direction = current_input
		
		if current_input.is_zero_approx():
			movement_direction = Vector3.ZERO
		else:
			var input_vector = Vector3(current_input.x, 0, current_input.y).normalized()
			movement_direction = camera_component.horizontal_pivot.global_transform.basis * input_vector
