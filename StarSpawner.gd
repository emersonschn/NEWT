# StarSpawner.gd
extends Node2D

@export var star_scene: PackedScene
@export var spawn_chance: float = 0.15 # 15% each timer tick
@export var spawn_y: float = -40.0

# optional: speed range per star
@export var min_speed: float = 50.0
@export var max_speed: float = 120.0

@onready var timer: Timer = $Timer
var spawn_paused: bool = false

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	
func pause_spawning_for(seconds: float) -> void:
	if spawn_paused:
		return
	spawn_paused = true
	
	# stop the spawn timer so nothing else can spawn
	timer.stop()
	await get_tree().create_timer(seconds).timeout
	spawn_paused = false
	timer.start()

func _on_timer_timeout() -> void:
	
	if spawn_paused:
		return
		
	if randf() > spawn_chance:
		return

	var star := star_scene.instantiate()
	add_child(star)

	# random X across the screen
	var w := random_star_x()
	star.position = Vector2(randf_range(0.0, w), spawn_y)

	# random fall speed
	star.fall_speed = randf_range(min_speed, max_speed)


	# when clicked, tell the main game to apply a random effect
	star.clicked.connect(func(): 
		#pause spawns for 10 seconds when clicked
		pause_spawning_for(10.0)
		get_tree().call_group("game", "apply_random_star_effect"))

func random_star_x() -> float:
	var w := float(get_viewport_rect().size.x)
	# spawn between 20% and 70% of the screen width
	return randf_range(w * 0.20, w * 0.70)
