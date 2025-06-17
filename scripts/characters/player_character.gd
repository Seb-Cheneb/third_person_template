class_name PlayerCharacter
extends Character


@export var camera_component: ThirdPersonCamera
@export var input_controller: InputController

var direction: Vector3 = Vector3.ZERO


func _ready() -> void:
	if not camera_component:
		Logger.warn(true, self, "camera component not set")
	if not input_controller:
		Logger.warn(true, self, "input controller not set")
		

func _physics_process(delta: float) -> void:
	get_direction()
	super._physics_process(delta)


func get_direction() -> void:
	direction = camera_component.horizontal_pivot.global_transform.basis * input_controller.input_vector
