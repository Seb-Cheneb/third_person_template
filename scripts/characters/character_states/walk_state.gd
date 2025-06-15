class_name WalkState
extends State

@export var actor: Character
@export var rig_pivot: Node3D
@export var camera_component: ThirdPersonCamera

@export_category("Animation")
@export var animation_tree: AnimationTree
@export var blendspace: String
@export var blendspace_value: float = 1
@export var animation_speed: float = 10
@export var animation_decay: int = 8

## the direction the actor is looking at
var direction: Vector3 = Vector3.ZERO
var animation_playback: AnimationNodeStateMachinePlayback


func _ready() -> void:
	super._ready()
	blendspace = "parameters/" + blendspace + "/blend_position"
	Logger.info(is_debugging, self, "blendspace set to \"" + blendspace + "\"")


func _physics_process(delta : float) -> void:
	# gradually set the blendspace value to the desired value
	animation_tree[blendspace] = move_toward(animation_tree[blendspace], blendspace_value, delta * animation_speed)
	
	var direction = get_movement_direction()
	#actor.velocity.x = exponential_decay(actor.velocity.x, direction.x * character_stats.get_base_speed(), decay, delta)
	#actor.velocity.z = exponential_decay(actor.velocity.z, direction.z * character_stats.get_base_speed(), decay, delta)
	actor.velocity.x = MathManager.exponential_decay(actor.velocity.x, direction.x * actor.character_stats.get_base_speed(), animation_decay, delta)
	actor.velocity.z = MathManager.exponential_decay(actor.velocity.z, direction.z * actor.character_stats.get_base_speed(), animation_decay, delta)
	actor.move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	pass
	#if event in ["move_left", "move_right", "move_forward", "move_back"]:
		#var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		#var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
		#var direction := camera_component.horizontal_pivot.global_transform.basis * input_vector
		#change_state_signal.emit("Walk", direction)


func enter() -> void:
	super.enter()


func exit() -> void:
	super.exit()


func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
	var direction := camera_component.horizontal_pivot.global_transform.basis * input_vector
	return direction
