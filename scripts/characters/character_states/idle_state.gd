class_name WalkState
extends State


@export var rig_pivot: Node3D
@export var camera_component: ThirdPersonCamera

@export_category("Animation")
@export var animation_tree: AnimationTree
@export var blendspace: String
@export var blendspace_value: float = -1
@export var animation_decay: float = 20
@export var animation_speed: float = 10

## the direction the actor is looking at
var direction: Vector3 = Vector3.ZERO
var animation_playback: AnimationNodeStateMachinePlayback


func _ready() -> void:
	blendspace = "parameters/" + blendspace + "/blend_position"
	Logger.info(is_debugging, self, "blendspace set to \"" + blendspace + "\"")

	
func on_process(delta : float) -> void:
	pass


func on_physics_process(delta : float) -> void:
	animation_tree[blendspace] = move_toward(animation_tree[blendspace], blendspace_value, delta * animation_speed)
	

func on_unhandled_input(event: InputEvent) -> void:
	if event in ["move_left", "move_right", "move_forward", "move_back"]:
		var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
		var direction := camera_component.horizontal_pivot.global_transform.basis * input_vector
		change_state_signal.emit("Walk", direction)


func enter() -> void:
	pass


func exit() -> void:
	pass
