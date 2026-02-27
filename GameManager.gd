extends Node

var end_time: float = 60.0
var final_time: float = 0.0
var session_length: float = 0.0

var ending_id: String = ""
var starting_bonus_time: float = 0
var starting_bonus_click: float = 0

func start_game() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")

func end_game(time_value: float, click_value: float, real_time: float) -> void:
	final_time = time_value
	session_length = real_time
	_determine_ending(time_value, click_value, real_time)
	get_tree().change_scene_to_file("res://Ending.tscn")

func _determine_ending(time_value: float, click_value: float, real_time: float) -> void:

	if click_value >= 31557600: # 1 year per click
		ending_id = "scholar"
		starting_bonus_time += 1000
		starting_bonus_click += 5
	else:
		ending_id = "normal"

func restart_game() -> void:
	start_game()

func quit_game() -> void:
	get_tree().quit()

func set_end_time(value: float) -> void:
	end_time = value

func add_end_time(value: float) -> void:
	end_time += value

func subtract_end_time(value: float) -> void:
	end_time -= value
	
func mult_time(value: float) -> void:
	end_time *= value

func reset_end_time(default_value: float = 3155760000.0) -> void:
	end_time = default_value
