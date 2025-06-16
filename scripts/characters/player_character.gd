class_name PlayerCharacter
extends Character

@export
var camera_component: ThirdPersonCamera

var input_direction: Vector2 = Vector2.ZERO
var input_vector: Vector3 = Vector3.ZERO

@export
var animation_decay: float = 10

func _physics_process(delta: float) -> void:
	set_movement_direction()
	ease_toward_direction(delta)


func set_movement_direction() -> void:
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	input_vector = Vector3(input_direction.x, 0, input_direction.y).normalized()
	movement_direction = camera_component.horizontal_pivot.global_transform.basis * input_vector


func ease_toward_direction(delta: float) -> void:
	# Only rotate if there's a valid movement direction
	if not movement_direction.is_zero_approx():
		var target_transform := pivot.global_transform.looking_at(pivot.global_position + movement_direction, Vector3.UP, true)
		pivot.global_transform = pivot.global_transform.interpolate_with(target_transform, 1.0 - exp(-animation_decay * delta))
