class_name MovementState
extends State


@export var actor: PlayerCharacter

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

# This state's movement direction
var movement_direction: Vector3 = Vector3.ZERO
var target_blendspace_value: float


func _physics_process(delta: float) -> void:
	if not actor.direction.is_zero_approx():
		update_blendspace(delta, idle_blendspace_value)
	else:
		update_blendspace(delta, running_blendspace_value)
		
		
## gradually set the blendspace value to the desired value
func update_blendspace(delta: float, blend_value: float) -> void:
	animation_tree[blendspace] = move_toward(
		animation_tree[blendspace], 
		blend_value, 
		delta * animation_speed
	)

#func _physics_process(delta: float) -> void:
	#update_movement_direction()
	#update_animation_target()
	#update_animation_blendspace(delta)
	#update_movement(delta)
	#update_rotation(delta)
	#
	#actor.apply_gravity(delta)
	#actor.move_and_slide()
#
#
#func update_movement_direction() -> void:
	## Only recalculate if input changed
	#if actor.input_changed:
		#if actor.input_direction.is_zero_approx():
			#movement_direction = Vector3.ZERO
		#else:
			#var input_vector = Vector3(actor.input_direction.x, 0, actor.input_direction.y).normalized()
			#movement_direction = actor.camera_component.horizontal_pivot.global_transform.basis * input_vector
#
#
#func update_animation_target() -> void:
	#target_blendspace_value = idle_blendspace_value if movement_direction.is_zero_approx() else running_blendspace_value
#
#
#func update_animation_blendspace(delta: float) -> void:
	#animation_tree[blendspace] = move_toward(
		#animation_tree[blendspace], 
		#target_blendspace_value, 
		#delta * animation_speed
	#)
#
#
#func update_movement(delta: float) -> void:
	#var target_speed = actor.character_stats.get_base_speed() if not movement_direction.is_zero_approx() else 0.0
	#
	#actor.velocity.x = MathManager.exponential_decay(
		#actor.velocity.x, 
		#movement_direction.x * target_speed, 
		#movement_decay, 
		#delta
	#)
	#actor.velocity.z = MathManager.exponential_decay( 
		#actor.velocity.z, 
		#movement_direction.z * target_speed, 
		#movement_decay, 
		#delta
	#)
#
#
#func update_rotation(delta: float) -> void:
	#if not movement_direction.is_zero_approx():
		#var target_transform := actor.pivot.global_transform.looking_at(
			#actor.pivot.global_position + movement_direction, 
			#Vector3.UP, 
			#true
		#)
		#actor.pivot.global_transform = actor.pivot.global_transform.interpolate_with(
			#target_transform, 
			#1.0 - exp(-rotation_decay * delta)
		#)
