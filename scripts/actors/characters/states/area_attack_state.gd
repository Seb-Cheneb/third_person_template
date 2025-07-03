class_name AreaAttackState
extends State

#test
@export_category("Character")
@export var actor: Character
@export var shape_cast: ShapeCast3D
@export var damage: float

@export_category("Animation")
@export var animation_tree: AnimationTree
@export var animation_name: String

var playback: AnimationNodeStateMachinePlayback
var position: Vector3 = Vector3.ZERO


func _ready() -> void:
	var checked_objects: Dictionary = {
		"actor": actor,
		"shape cast": shape_cast,
		"animation name": animation_name,
		"animation tree": animation_tree		
	}
	
	if Logger.check_objects(is_debugging, self, checked_objects):
		playback = animation_tree["parameters/playback"] # if the tree node has been initialized set the playback value
		
	actor.health_component.defeat_signal.connect(
		func defeat_state() -> void:
			change_state_signal.emit("Defeat")
	)
	
	animation_tree.animation_finished.connect(check_animation)


#func _physics_process(delta: float) -> void:
	#Logger.info(is_debugging, self, "actor global transform: " + str(actor.global_transform) + ", shape cast global transform " + str(shape_cast.global_transform))
	#shape_cast.global_transform = actor.global_transform * shape_cast.global_transform


func enter() -> void:
	super.enter()
	actor.velocity.x = 0
	actor.velocity.z = 0
	playback.travel(animation_name)
	deal_damage(damage)


func deal_damage(_damage: float) -> void:
	for collision_id in shape_cast.get_collision_count():
		var collider = shape_cast.get_collider(collision_id)
		if collider is Character:
			collider.health_component.take_damage(_damage)
			actor.health_component.take_damage(_damage)
			Logger.info(is_debugging, self, "dealing " + str(_damage) + " damage to object with collider id: " + str(collider))


func check_animation(_animation_name: String) -> void:
	if animation_name == _animation_name:
		change_state_signal.emit("Movement") 
