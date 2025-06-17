class_name MovementState
extends State

@export_category("Character")
@export var actor: PlayerCharacter

@export_category("Movement")
@export var turn_speed: float = 10.0
@export var acceleration: float = 10
@export var deceleration: float = 8

@export_category("Animation")
@export var animation_tree: AnimationTree
@export var blendspace: String:
	set(value):
		blendspace = "parameters/" + value + "/blend_position"
		Logger.info(is_debugging, self, "blendspace set to \"" + blendspace + "\"")
@export var idle_blendspace_value: float = -1.0
@export var running_blendspace_value: float = 1.0
@export var animation_speed: float = 30.0
@export var animation_decay: float = 8.0


func _physics_process(delta: float) -> void:
	# adjust the animation based on the direction vector of the player
	if actor.direction.is_zero_approx():
		update_blendspace(delta, idle_blendspace_value, animation_decay)
		update_movement(delta, deceleration)
	else:
		update_blendspace(delta, running_blendspace_value, animation_speed)
		update_movement(delta, acceleration)
		update_rotation(delta)
	actor.move_and_slide()
	
		
## gradually set the blendspace value to the desired value
func update_blendspace(delta: float, blendspace_value: float, decay: float) -> void:
	animation_tree[blendspace] = move_toward(
		animation_tree[blendspace], 
		blendspace_value, 
		delta * decay
	)


func update_rotation(delta: float) -> void:
	if not actor.direction.is_zero_approx():
		var target_transform := actor.pivot.global_transform.looking_at(
			actor.pivot.global_position + actor.direction, 
			Vector3.UP, 
			true
		)
		actor.pivot.global_transform = actor.pivot.global_transform.interpolate_with(
			target_transform, 
			1.0 - exp(-turn_speed * delta)
		)
		
	
func update_movement(delta: float, decay: float) -> void:
	actor.velocity.x = MathManager.exponential_decay(
		actor.velocity.x, 
		actor.direction.x * actor.character_stats.get_base_speed(), 
		decay, 
		delta
	)
	
	actor.velocity.z = MathManager.exponential_decay( 
		actor.velocity.z, 
		actor.direction.z * actor.character_stats.get_base_speed(), 
		decay, 
		delta
	)
