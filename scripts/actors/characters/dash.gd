class_name Dash
extends Node3D


@export var player: Player
@export var duration: float = 0.2
@export_enum("Dash", "Idle", "Overhead") var animation_name: String = "Dash"
@export var speed_multiplier: float = 3.0

var direction = Vector3.ZERO
var time_remaining = 0.0

@onready var timer: Timer = $Timer
@onready var gpu_particles_3d: GPUParticles3D = $GPUParticles3D


func _ready() -> void:
	timer.wait_time = player.character_stats.get_dash_cooldown()


func _physics_process(delta: float) -> void:
	if direction.is_zero_approx():
		return
		
	player.velocity = direction * player.character_stats.get_base_speed() * speed_multiplier
	
	if time_remaining <= 0:
		direction = Vector3.ZERO
		gpu_particles_3d.emitting = false
		return
		
	time_remaining -= delta


func _unhandled_input(event: InputEvent) -> void:
	if not timer.is_stopped():
		return
	# spaghetti for a bug: pressing dash after being killed will reset to idle
	if not player.is_physics_processing():
		return
		
	if event.is_action_pressed("dash"):
		direction = player.get_movement_direction()
		
		if not direction.is_zero_approx():
			player.rig.travel(animation_name)
			gpu_particles_3d.emitting = true
			timer.start()
			time_remaining = duration
			print("dashing")
