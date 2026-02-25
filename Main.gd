extends Node2D

# currency / score
var total_time: int = 0

# time per click
var click: float = 1.00

# upgrade data sun
const CLICK_SUN_UPGRADE := "            Click Power +1seconds"
const CLICK_SUN_UPGRADE_BASE_COST := 60
const CLICK_SUN_UPGRADE_GROWTH := 1.15
var click_sun_upgrade_level: int = 0

# upgrade data sundial
const CLICK_SUNDIAL_UPGRADE := "                 Click Power +10seconds"
const CLICK_SUNDIAL_UPGRADE_BASE_COST := 60 * 29
const CLICK_SUNDIAL_UPGRADE_GROWTH := 1.15
var click_sundial_upgrade_level: int = 0

# upgrade water clock
const CLICK_WATERCLOCK_UPGRADE := "                 Click Power +45seconds"
const CLICK_WATERCLOCK_UPGRADE_BASE_COST := 60 * 59
const CLICK_WATERCLOCK_UPGRADE_GROWTH := 1.15
var click_waterclock_upgrade_level: int = 0


# begin
@onready var time_label: Label = $TimeCountLabel
@onready var clock_button: TextureButton = $ClockButton
@onready var rate_label: Label = $TimePerSecLabel

# sun upgrade
@onready var sun_title: Label = $UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var sun_purchase_button: Button = $UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton

# sundial upgrade
@onready var sundial_title: Label = $UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunDialUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var sundial_purchase_button: Button = $UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunDialUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton

# waterclock upgrade
@onready var waterclock_title: Label = $UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/WaterClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title
@onready var waterclock_purchase_button: Button = $UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/WaterClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton

func _ready() -> void:
	clock_button.pressed.connect(_on_clock_button_pressed)
	sun_purchase_button.pressed.connect(_on_sun_purchase_button)
	sundial_purchase_button.pressed.connect(_on_sundial_purchase_button)
	waterclock_purchase_button.pressed.connect(_on_waterclock_purchase_button)
	_update_label()

func _on_clock_button_pressed() -> void:
	_flash_button()
	total_time += click
	_update_label()

func _on_sun_purchase_button() -> void:
	var cost := _get_sun_upgrade_cost()

	if total_time < cost:
		return

	total_time -= cost
	click_sun_upgrade_level += 1

	# increase click power
	click += 1

	_update_label()
	
func _on_sundial_purchase_button() -> void:
	var cost := _get_sundial_upgrade_cost()

	if total_time < cost:
		return

	total_time -= cost
	click_sundial_upgrade_level += 1

	# increase click power
	click += 10

	_update_label()
	
func _on_waterclock_purchase_button() -> void:
	var cost_waterclock := _get_waterclock_upgrade_cost()

	if total_time < cost_waterclock:
		return

	total_time -= cost_waterclock
	click_waterclock_upgrade_level += 1

	# increase click power
	click += 45

	_update_label()

func _get_sun_upgrade_cost() -> int:
	var cost_f := float(CLICK_SUN_UPGRADE_BASE_COST) * pow(CLICK_SUN_UPGRADE_GROWTH, float(click_sun_upgrade_level))
	return int(ceil(cost_f))
	
func _get_sundial_upgrade_cost() -> int:
	var cost_f := float(CLICK_SUNDIAL_UPGRADE_BASE_COST) * pow(CLICK_SUNDIAL_UPGRADE_GROWTH, float(click_sundial_upgrade_level))
	return int(ceil(cost_f))

func _get_waterclock_upgrade_cost() -> int:
	var cost_f := float(CLICK_WATERCLOCK_UPGRADE_BASE_COST) * pow(CLICK_WATERCLOCK_UPGRADE_GROWTH, float(click_waterclock_upgrade_level))
	return int(ceil(cost_f))

func _flash_button() -> void:
	clock_button.modulate = Color(1.5, 1.5, 1.5, 1.0)

	var tween := create_tween()
	tween.tween_property(
		clock_button,
		"modulate",
		Color(1, 1, 1, 1),
		0.12
	)

func _get_time_label(total_time: int) -> String:
	if total_time < 60:
		return "%d seconds" % total_time
	
	elif total_time < 60 * 60:
		var minutes := float(total_time) / 60.0
		return "%.2f minutes" % minutes
	
	else:
		var hours := float(total_time) / 3600.0
		return "%.2f hours" % hours

func _get_rate_ratio(click: int) -> float:
	if click >= 60.00 && click < 3600:
		return click / 60.00
	elif click >= 3600:
		return click / 60.00
	else:
		return click

func _get_rate_label(click: int) -> String:
	if click < 60:
		return "(seconds)"
	elif click < 3600:
		return "(minutes)"
	else:
		return"(hours)"

func _update_label() -> void:
	time_label.text = "Time: " + _get_time_label(total_time)
	rate_label.text = "Rate: %.2f%s per click" % [_get_rate_ratio(click),_get_rate_label(click)]

	var cost_sun := _get_sun_upgrade_cost()
	sun_title.text = "%s (Lvl %d)\nCost: %.2f%s" % [
		CLICK_SUN_UPGRADE,
		click_sun_upgrade_level,
		_get_rate_ratio(cost_sun),
		_get_rate_label(cost_sun)
	]

	sun_purchase_button.disabled = total_time < cost_sun
	
	var cost_sundial := _get_sundial_upgrade_cost()
	sundial_title.text = "%s (Lvl %d)\nCost: %.2f%s" % [
		CLICK_SUNDIAL_UPGRADE,
		click_sundial_upgrade_level,
		_get_rate_ratio(cost_sundial),
		_get_rate_label(cost_sundial)
	]
	
	sundial_purchase_button.disabled = total_time < cost_sundial
	
	var cost_waterclock := _get_waterclock_upgrade_cost()
	waterclock_title.text = "%s (Lvl %d)\nCost: %.2f%s" % [
		CLICK_WATERCLOCK_UPGRADE,
		click_waterclock_upgrade_level,
		_get_rate_ratio(cost_waterclock),
		_get_rate_label(cost_waterclock)
	]
	
	waterclock_purchase_button.disabled = total_time < cost_waterclock
	
	
