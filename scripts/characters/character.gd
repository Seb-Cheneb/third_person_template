class_name Character
extends CharacterBody3D

@export var character_stats: CharacterStats
@export var pivot: Node3D
@export var gravity_modifier: float = 1.0

var movement_direction: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_modifier
