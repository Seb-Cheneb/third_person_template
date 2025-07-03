class_name Character
extends CharacterBody3D

@export var pivot: Node3D
@export var collision_shape: CollisionShape3D
@export var health_component: HealthComponent
@export var character_stats: CharacterStats
@export var gravity_modifier: float = 1.0

var direction: Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_modifier
