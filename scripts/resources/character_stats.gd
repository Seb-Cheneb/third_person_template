class_name CharacterStats
extends Resource

signal level_up_signal

@export var is_debugging: bool = false
var name_of_class: String = get_script().get_path().get_file().get_basename()

class Ability:
	var ability_score: int = 25:
		set(value):
			ability_score = clamp(value, 0, 100)
	var min_modifier: float
	var max_modifier: float


	func _init(_min: float, _max: float) -> void:
		min_modifier = _min
		max_modifier = _max


	func percentile_lerp(min_boundary: float, max_boundary: float) -> float:
		return lerp(min_boundary, max_boundary, ability_score / 100.0)


	func get_modifier() -> float:
		return percentile_lerp(min_modifier, max_modifier)
		
	
	func increase() -> void:
		ability_score += randi_range(2, 5)


const MIN_DASH_COOLDOWN := 1.5
const MAX_DASH_COOLDOWN := 0.5

var level: int = 1
var experience: int = 0:
	set(value):
		experience = value
		var boundary: int = percentage_level_up_boundary()
		while experience > boundary:
			experience -= boundary
			level_up()
			boundary = percentage_level_up_boundary()
			
			
## damage bonus on attack
var strength := Ability.new(2.0, 12.0)
## movement speed in m/s
var speed := Ability.new(3.0, 7.0)
## hp bonus per level
var endurance := Ability.new(5.0, 25.0)
## crit chance
var agility := Ability.new(0.05, 0.25)


func get_base_speed() -> float:
	return speed.get_modifier()
	

func get_damage_modifier() -> float:
	return strength.get_modifier()
	

func get_crit_chance() -> float:
	return agility.get_modifier()


func get_max_hp() -> int:
	return 20 + int(endurance.get_modifier() * level)

		
func get_dash_cooldown() -> float:
	var dash_cooldown: float = agility.percentile_lerp(MIN_DASH_COOLDOWN, MAX_DASH_COOLDOWN)
	Logger.info(is_debugging, self, "dash cooldown = " + str(dash_cooldown))
	return dash_cooldown
	

func level_up() -> void:
	level += 1
	strength.increase()
	agility.increase()
	speed.increase()
	endurance.increase()
	level_up_signal.emit()


## higher levels require more exp
func percentage_level_up_boundary() -> int:
	return int(50 * pow(1.2, level))
	

## the curve is more stable, higher levels require less exp than the percentage based approach
func cubic_level_up_boundary() -> int:
	return int(50 + pow(level, 3))
