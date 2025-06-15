class_name Character
extends CharacterBody3D

@export
var character_stats: CharacterStats

@export
var pivot: Node3D

var movement_direction: Vector3 = Vector3.ZERO

var gravity: Gravity = Gravity.new(self)
