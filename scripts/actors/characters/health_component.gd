class_name HealthComponent 
extends Node

signal defeat_signal
signal health_changed_signal

@export var body: PhysicsBody3D
@export var max_health: float

@export_category("Debugging")
@export var is_debugging: bool = false

var current_health: float:
	get:
		return current_health
	set(value):
		current_health = max(value, 0.0)
		if current_health == 0.0:
			defeat_signal.emit()
		health_changed_signal.emit()
		Logger.info(is_debugging, self, "health changed by " + str(value))


func _ready() -> void:
	current_health = max_health


func update_max_health(_max_hp: float) -> void:
	max_health = _max_hp
	current_health = max_health
	print("max health: ", max_health)
	

func take_damage(_damage: float) -> void:
	current_health -= _damage
	VfxManager.spawn_damage_number(_damage, Color.RED, body.global_position)
