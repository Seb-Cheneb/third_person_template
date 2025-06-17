class_name HeavyAttackState
extends State


@export_category("Character")
@export var actor: PlayerCharacter

@export_category("Animation")
@export var animation_tree: AnimationTree
@export var animation_name: String

var playback: AnimationNodeStateMachinePlayback

@onready var shape_cast_3d: ShapeCast3D = $ShapeCast3D


func _ready() -> void:
	animation_tree.animation_finished.connect(check_animation)
	if animation_tree:
		playback = animation_tree["parameters/playback"]


func enter() -> void:
	super.enter()
	actor.velocity.x = 0
	actor.velocity.z = 0
	playback.travel(animation_name)


func deal_damage(_damage: float) -> void:
	for collision_id in shape_cast_3d.get_collision_count():
		var collider = shape_cast_3d.get_collider(collision_id)
		if collider is Player or collider is Enemy:
			collider.health_component.take_damage(_damage)
			Logger.info(is_debugging, self, "dealing " + str(_damage) + " damage to object with collider id: " + str(collider))


func check_animation(_animation_name: String) -> void:
	if animation_name == _animation_name:
		change_state_signal.emit("Movement") 
