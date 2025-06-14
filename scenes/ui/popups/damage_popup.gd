class_name DamagePopup
extends Node3D

@onready var label_3d: Label3D = $Label3D


func setup(_damage: int, _color: Color, _position: Vector3) -> void:
	if not is_inside_tree():
		await ready
	label_3d.text = str(_damage)
	label_3d.modulate = _color
	global_position = _position
