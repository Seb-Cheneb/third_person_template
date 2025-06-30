class_name DeathState
extends State

@export var character: Character

@export_category("Animation")
@export var animation_tree: AnimationTree
@export var animation_name: String

var playback: AnimationNodeStateMachinePlayback


func _ready() -> void:
	super._ready()
	if not animation_tree:
		Logger.warn(is_debugging, self, "animation tree not set")
	else:
		# if the tree node has been initialized set the playback value
		playback = animation_tree["parameters/playback"]


func enter() -> void:
	super.enter()
	playback.travel(animation_name)
	character.set_physics_process(false)
	character.collision_shape.disabled = true
	
