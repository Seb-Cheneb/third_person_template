class_name MovementState
extends State

@export var actor: Character
@export_category("Animation")
@export var animation_tree: AnimationTree
@export var blendspace: String:
	set(value):
		blendspace = "parameters/" + value + "/blend_position"
		Logger.info(is_debugging, self, "blendspace set to \"" + blendspace + "\"")

@export var idle_blendspace_value: float = -1.0
@export var running_blendspace_value: float = 1.0
@export var animation_speed: float = 10.0
@export var movement_decay: float = 8.0
@export var rotation_decay: float = 10.0

# Current target blendspace value
var target_blendspace_value: float

func _physics_process(delta: float) -> void:
	update_animation_target()
	update_animation_blendspace(delta)
	update_movement(delta)
	update_rotation(delta)
	actor.move_and_slide()

func update_animation_target() -> void:
	# Determine which animation we should be playing
	if actor.movement_direction.is_zero_approx():
		target_blendspace_value = idle_blendspace_value
	else:
		target_blendspace_value = running_blendspace_value

func update_animation_blendspace(delta: float) -> void:
	animation_tree[blendspace] = move_toward(
		animation_tree[blendspace], 
		target_blendspace_value, 
		delta * animation_speed
	)

func update_movement(delta: float) -> void:
	var target_speed = actor.character_stats.get_base_speed() if not actor.movement_direction.is_zero_approx() else 0.0
	
	actor.velocity.x = MathManager.exponential_decay(
		actor.velocity.x, 
		actor.movement_direction.x * target_speed, 
		movement_decay, 
		delta
	)
	actor.velocity.z = MathManager.exponential_decay(
		actor.velocity.z, 
		actor.movement_direction.z * target_speed, 
		movement_decay, 
		delta
	)

func update_rotation(delta: float) -> void:
	# Only rotate if there's a valid movement direction
	if not actor.movement_direction.is_zero_approx():
		var target_transform := actor.pivot.global_transform.looking_at(
			actor.pivot.global_position + actor.movement_direction, 
			Vector3.UP, 
			true
		)
		actor.pivot.global_transform = actor.pivot.global_transform.interpolate_with(
			target_transform, 
			1.0 - exp(-rotation_decay * delta)
		)
