class_name HealthComponent 
extends Node

signal defeat
signal health_changed

@export var body: PhysicsBody3D

var max_health: float
var current_health: float:
	get:
		return current_health
	set(value):
		current_health = max(value, 0.0)
		if current_health == 0.0:
			defeat.emit()
		health_changed.emit()
		print("Current health: ", current_health)


func update_max_health(_max_hp: float) -> void:
	max_health = _max_hp
	current_health = max_health
	print("max health: ", max_health)
	

func take_damage(_damage: float) -> void:
	current_health -= _damage
	VfxManager.spawn_damage_number(_damage, Color.RED, body.global_position)
