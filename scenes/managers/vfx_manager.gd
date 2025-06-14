extends Node3D

const DAMAGE_POPUP = preload("res://scenes/ui/popups/damage_popup.tscn")

func spawn_damage_number(_damage: int, _color: Color, _position: Vector3) -> void:
	var new_number = DAMAGE_POPUP.instantiate()
	new_number.setup(_damage, _color, _position)
	add_child(new_number)
