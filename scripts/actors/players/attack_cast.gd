class_name AttackCast 
extends RayCast3D

@export var debug: bool = false


func deal_damage(_damage_taken: float) -> void:
	if not is_colliding():
		return
	var collider = get_collider() # the object the ray cast is colliding with
	if collider is Enemy:
		collider.health_component.take_damage(_damage_taken)
		add_exception(collider) # once the object is hit, add it as an exception to the ray cast
	if debug: 
		print("Dealing ", _damage_taken, " damage to object with collider id: ", collider)
