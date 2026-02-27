# Star.gd
extends Area2D

signal clicked

@export var fall_speed: float = 100.0
@export var kill_y_padding: float = 64.0
@export var rotation_speed: float = 1.5

func _ready() -> void:
	if randf() < .5:
		rotation_speed *= -1

func _process(delta: float) -> void:
	position.y += fall_speed * delta
	
	# rotate while falling
	rotation += rotation_speed * delta

	# delete once it falls below the screen
	var screen_h := get_viewport_rect().size.y
	if position.y > screen_h + kill_y_padding:
		queue_free()

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		emit_signal("clicked")
		queue_free()
