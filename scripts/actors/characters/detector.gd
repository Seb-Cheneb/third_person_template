class_name Detector
extends Node

signal get_collider_signal

@export_category("Debugging")
@export var is_debugging: bool = false

@onready var detector: Detector = $"."

func _physics_process(delta: float) -> void:
	for collision_id in detector.get_collision_count():
		var collider = detector.get_collider(collision_id)
		get_collider_signal.emit(collider)
		Logger.info(is_debugging, self, "collided with " + str(collision_id))
