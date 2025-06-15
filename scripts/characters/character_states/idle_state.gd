class_name IdleState
extends State


@export var actor: CharacterBody3D
@export var rig_pivot: Node3D
@export var camera_component: ThirdPersonCamera

@export_category("Animation")
@export var animation_tree: AnimationTree
@export var blendspace: String
@export var blendspace_value: float = -1
@export var animation_speed: float = 10


func _ready() -> void:
	super._ready()
	blendspace = "parameters/" + blendspace + "/blend_position"
	Logger.info(is_debugging, self, "blendspace set to \"" + blendspace + "\"")


func _physics_process(delta : float) -> void:
	# gradually set the blendspace value to the desired value
	animation_tree[blendspace] = move_toward(animation_tree[blendspace], blendspace_value, delta * animation_speed)
	actor.move_and_slide()
	
	
func _unhandled_input(event: InputEvent) -> void:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input_dir != Vector2.ZERO:
		change_state_signal.emit("walk")


func enter() -> void:
	super.enter()


func exit() -> void:
	super.exit()
