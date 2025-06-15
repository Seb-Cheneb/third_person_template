class_name Player
extends CharacterBody3D

const JUMP_VELOCITY = 4.5
const DECAY: float = 8.0

@export_category("Animation")
@export var camera_component: ThirdPersonCamera
@export var animation_decay: float = 20.0
@export var attack_move_speed: float = 3.0 ## The movement speed of the rig when it is attacking 

@export_category("RPG Stats")
@export var character_stats: CharacterStats

@onready var rig_pivot: Node3D = $RigPivot
@onready var rig: Rig = $RigPivot/Rig
@onready var attack_cast: RayCast3D = %AttackCast ## raycast for the right hand weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var area_attack: AreaAttack = $RigPivot/Rig/AreaAttack
@onready var dash: Dash = $RigPivot/Dash

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")  # default gravity of the engine
var attack_direction: Vector3 = Vector3.ZERO # stores the direction the player moves when attacking


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	update_max_health()
	character_stats.level_up_signal.connect(update_max_health)
	character_stats.level_up_signal.connect(
		func(): dash.timer.wait_time = character_stats.get_dash_cooldown()
	)


func _physics_process(delta: float) -> void:
	camera_component.on_physics_process()
	var direction := get_movement_direction()
	#rig.update_animation_tree(direction)
	#handle_idle_physics_frame(delta, direction)
	handle_slashing_physics_frame(delta)
	handle_overhead_physics_frame(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_gain_xp"):
		character_stats.experience += 10000
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if rig.is_idle():
		if event.is_action_pressed("click"):
			slash_attack()
		if event.is_action_pressed("right_click"):
			rig.travel("Overhead")
	camera_component.on_unhandled_input(event)


func get_movement_direction() -> Vector3:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var input_vector := Vector3(input_dir.x, 0, input_dir.y).normalized()
	var direction := camera_component.horizontal_pivot.global_transform.basis * input_vector
	return direction


func look_toward_direction(direction: Vector3, delta: float) -> void:
	var target_transform := rig_pivot.global_transform.looking_at(rig_pivot.global_position + direction, Vector3.UP, true)
	rig_pivot.global_transform = rig_pivot.global_transform.interpolate_with(target_transform, 1.0 - exp(-animation_decay * delta))
	
	
func slash_attack() -> void:
	rig.travel("Slash")
	# if the character isn't moving, the vector will be zero
	attack_direction = get_movement_direction()
	if attack_direction.is_zero_approx():
		# stores the direction the player is facing when the attack is made
		attack_direction = rig.global_basis * Vector3(0, 0, 1)
	# clear all the object the ray cast collided with previously
	attack_cast.clear_exceptions()


func handle_slashing_physics_frame(delta: float) -> void:
	if not rig.is_slashing():
		return
	# set the direction of the rig
	velocity.x = attack_direction.x * attack_move_speed
	velocity.z = attack_direction.z * attack_move_speed
	# update the direction of the rig
	look_toward_direction(attack_direction, delta)
	
	var damage = character_stats.get_damage_modifier() + 10.0
	if character_stats.get_crit_chance() >= randf():
		attack_cast.deal_damage(damage * 2)
	else:
		attack_cast.deal_damage(damage)
	

func handle_idle_physics_frame(delta: float, direction: Vector3) -> void:
	# spaghetti code, added is dashing as well ...
	if not rig.is_idle() and not rig.is_dashing():
		return
	velocity.x = exponential_decay(velocity.x, direction.x * character_stats.get_base_speed(), DECAY, delta)
	velocity.z = exponential_decay(velocity.z, direction.z * character_stats.get_base_speed(), DECAY, delta)
	if direction:
		look_toward_direction(direction, delta)


func handle_overhead_physics_frame(delta: float) -> void:
	if not rig.is_overhead():
		return
	velocity.x = 0.0
	velocity.z = 0.0


func update_max_health() -> void:
	health_component.update_max_health(character_stats.get_max_hp())


func _on_health_component_defeat() -> void:
	rig.travel("Defeat")
	collision_shape_3d.disabled = true
	set_physics_process(false)


func _on_rig_heavy_attack() -> void:
	var damage = character_stats.get_damage_modifier() + 20.0
	if character_stats.get_crit_chance() >= randf():
		area_attack.deal_damage(damage * 2)
	else:
		area_attack.deal_damage(damage)


## returns a linear interpolation that is FRAMERATE INDEPENDENT
func exponential_decay(_start: float, _end: float, decay: float, delta: float) -> float:
	return _end + (_start - _end) * exp(-decay * delta)
