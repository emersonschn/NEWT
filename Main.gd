extends Control

@onready var score_label: Label = $ScoreLabel
@onready var PerClickLabel: Label = $PerClickLabel
@onready var UpgradeCostLabel: Label = $UpgradeCostLabel
@onready var UpgradeCostLabel1: Label = $UpgradeCostLabel1
@onready var click_button: Button = $ClickButton
@onready var upgrade_button: Button = $UpgradeButton
@onready var upgrade_button1: Button = $UpgradeButton1

var score: int = 0
var points_per_click: int = 1
var upgrade_cost: int = 10
var upgrade_cost1: int = 100

func _ready() -> void:
	update_ui()
	click_button.pressed.connect(_on_click_pressed)
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	upgrade_button1.pressed.connect(_on_upgrade_pressed1)

func _on_click_pressed() -> void:
	score += points_per_click
	update_ui()

func _on_upgrade_pressed() -> void:
	if score >= upgrade_cost:
		score -= upgrade_cost
		points_per_click += 1
		# simple scaling cost
		upgrade_cost = int(upgrade_cost * 1.5) + 1
		update_ui()
func _on_upgrade_pressed1() -> void:
	if score >= upgrade_cost1:
		score -= upgrade_cost1
		points_per_click += 3
		# simple scaling cost
		upgrade_cost1 = int(upgrade_cost1 * 1.5) + 1
		update_ui()

func update_ui() -> void:
	score_label.text = "Score: %d" % [score]
	PerClickLabel.text = "Per Click: %d" %[points_per_click]
	UpgradeCostLabel.text = "Upgrade Cost: %d" % [upgrade_cost]
	UpgradeCostLabel1.text = "Upgrade Cost: %d" % [upgrade_cost1]
	upgrade_button.disabled = score < upgrade_cost
	upgrade_button1.disabled = score < upgrade_cost1
