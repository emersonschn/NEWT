
extends Node3D

@export var min_speed := 0.05      # rad/sec at very low click
@export var max_speed := 2.5       # rad/sec at very high click
@export var rate_scale := 0.02     # how fast speed ramps with click
@export var reverse_burst := 2.5   # rad/sec backwards burst
@export var reverse_time := 0.25   # seconds

var _target_speed := 0.1
var _reverse_override := 0.0

# this function makes the earth spin
func _process(delta: float) -> void:
	var speed := _target_speed + _reverse_override
	rotate_y(speed * delta)

# this function spins the earth based on your click rate
func set_click_rate(click_value: float) -> void:
	# Map click_value (seconds per click) -> spin speed smoothly.
	# Using log keeps growth reasonable for big numbers.
	# speed = clamp(min + log(1+click)*rate_scale, min, max)
	var s := min_speed + log(1.0 + click_value) / log(10.0) * (max_speed - min_speed) * rate_scale
	_target_speed = clamp(s, min_speed, max_speed)

# this function spins the earth backwards when you purchase
# an upgrade
func reverse_spin_burst() -> void:
	# Kick backwards quickly, then fade back to normal.
	_reverse_override = -reverse_burst
	var t := create_tween()
	t.tween_property(self, "_reverse_override", 0.0, reverse_time).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
