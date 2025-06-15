class_name WalkState
extends State

@export var actor: Character
@export var camera_component: ThirdPersonCamera

@export_category("Animation")
@export var animation_tree: AnimationTree
@export var blendspace: String
@export var blendspace_value: float = 1
@export var animation_speed: float = 10
@export var animation_decay: int = 8


var input_direction: Vector2
var input_vector: Vector3


func _ready() -> void:
	super._ready()
	blendspace = "parameters/" + blendspace + "/blend_position"
	Logger.info(is_debugging, self, "blendspace set to \"" + blendspace + "\"")


func _physics_process(delta : float) -> void:
	# gradually set the blendspace value to the desired value
	animation_tree[blendspace] = move_toward(
		animation_tree[blendspace], 
		blendspace_value, 
		delta * animation_speed
	)
	
	actor.movement_direction = camera_component.horizontal_pivot.global_transform.basis * input_vector
	
	if actor.movement_direction.is_zero_approx():
		change_state_signal.emit("idle")
		return  # Exit early to avoid processing movement
	
	actor.velocity.x = MathManager.exponential_decay(
		actor.velocity.x, 
		actor.movement_direction.x * actor.character_stats.get_base_speed(), 
		animation_decay, delta
	)
	actor.velocity.z = MathManager.exponential_decay(
		actor.velocity.z, 
		actor.movement_direction.z * actor.character_stats.get_base_speed(), 
		animation_decay, delta
	)
	
	look_toward_direction(actor.movement_direction, delta)
	actor.move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	input_vector = Vector3(input_direction.x, 0, input_direction.y).normalized()


func look_toward_direction(direction: Vector3, delta: float) -> void:
	var target_transform := actor.pivot.global_transform.looking_at(actor.pivot.global_position + direction, Vector3.UP, true)
	actor.pivot.global_transform = actor.pivot.global_transform.interpolate_with(target_transform, 1.0 - exp(-animation_decay * delta))
