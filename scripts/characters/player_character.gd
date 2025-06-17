class_name PlayerCharacter
extends Character


@export 
var camera_component: ThirdPersonCamera

## A component that takes care of updating the movement input and loads all the keybinds and their actions
@export
var input_controller: InputController

var direction: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	get_direction()
	super._physics_process(delta)


func get_direction() -> void:
	direction = camera_component.horizontal_pivot.global_transform.basis * input_controller.input_vector
