extends Node

## returns a linear interpolation that is FRAMERATE INDEPENDENT
func exponential_decay(_start: float, _end: float, decay: float, delta: float) -> float:
	return _end + (_start - _end) * exp(-decay * delta)
