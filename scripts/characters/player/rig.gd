class_name Rig extends Node3D

signal heavy_attack

@export var animation_speed: float = 10.0

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
## a reference to the skeleton that holds all the meshes for the characters
@onready var _skeleton_3d: Skeleton3D = $CharacterRig/GameRig/Skeleton3D
## the meshes for the enemies
@onready var _villager_meshes: Array[MeshInstance3D] = [
	$CharacterRig/GameRig/Skeleton3D/Villager_01,
	$CharacterRig/GameRig/Skeleton3D/Villager_02
]

var run_path: String = "parameters/MoveSpace/blend_position"
var run_weight_target: float = -1.0


func _physics_process(delta: float) -> void:
	animation_tree[run_path] = move_toward(animation_tree[run_path], run_weight_target, delta * animation_speed)


func update_animation_tree(_direction: Vector3) -> void:
	if _direction.is_zero_approx():
		run_weight_target = -1.0
	else:
		run_weight_target = 1.0


func travel(animation_name: String) -> void:
	playback.travel(animation_name)
	
	
func is_idle() -> bool:
	return playback.get_current_node() == "MoveSpace"
	
	
func is_dashing() -> bool:
	return playback.get_current_node() == "Dash"
	
	
func is_slashing() -> bool:
	return playback.get_current_node() == "Slash"


func is_overhead() -> bool:
	return playback.get_current_node() in ["Overhead", "OverheadRecover"]
	
	
func set_active_mesh(active_mesh: MeshInstance3D) -> void:
	for mesh in _skeleton_3d.get_children():
		mesh.visible = false
	active_mesh.visible = true


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Overhead":
		heavy_attack.emit()
