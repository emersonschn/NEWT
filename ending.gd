extends Control


@onready var time_label = $VBoxContainer/FinalTime
@onready var restart_button = $VBoxContainer/Start
@onready var quit_button = $VBoxContainer/Quit


func _ready():
	time_label.text = "Final Time: " + str(int(GameManager.final_time))

	restart_button.pressed.connect(GameManager.restart_game)
	quit_button.pressed.connect(GameManager.quit_game)
