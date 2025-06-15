class_name Gravity
extends Node

var actor: Character

func _init(_actor: Character) -> void:
	actor = _actor

func _physics_process(delta: float) -> void:
	if not actor.is_on_floor():
		actor.velocity += actor.get_gravity() * delta
		Logger.info(true, self, "modifying the velocity " + str(actor.velocity))
