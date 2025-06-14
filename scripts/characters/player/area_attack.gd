class_name AreaAttack
extends ShapeCast3D
	 
@export var debug_mode: bool = false


func deal_damage(_damage: float) -> void:
	for collision_id in get_collision_count():
		var collider = get_collider(collision_id)
		if collider is Player or collider is Enemy:
			collider.health_component.take_damage(_damage)
		if debug_mode: 
			print("Dealing ", _damage, " damage to object with collider id: ", collider)

	
