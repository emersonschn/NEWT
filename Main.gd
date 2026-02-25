# Main.gd
extends Node2D

var total_time: float = 0.0
var click: float = 1.0

@onready var time_label: Label = $TimeCountLabel
@onready var clock_button: TextureButton = $ClockButton
@onready var rate_label: Label = $TimePerSecLabel
@onready var earth_spinner := $EarthViewport/EarthWorld/EarthMesh
@onready var cloud_spinner := $EarthViewport/EarthWorld/CloudMesh

# --- Upgrades data ---
var upgrades := {}        # id -> Upgrade
var upgrade_ui := {}      # id -> { "title": Label, "button": Button }

# this function initializes the start game
func _ready() -> void:
	clock_button.pressed.connect(_on_clock_button_pressed)
	earth_spinner.set_click_rate(click)
	cloud_spinner.set_click_rate(click)

	# Bind each upgrade's UI
	_register_upgrade_ui(
		"sun",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)
	
	_register_upgrade_ui(
		"obelisk",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/ObeliskUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/ObeliskUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)

	_register_upgrade_ui(
		"sundial",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunDialUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunDialUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)

	_register_upgrade_ui(
		"waterclock",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/WaterClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/WaterClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)
	
	_register_upgrade_ui(
		"candleclock",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/CandleClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/CandleClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)
	
	_register_upgrade_ui(
		"hourglass",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/HourGlassUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/HourGlassUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)
	
	_register_upgrade_ui(
		"mechanicalclock",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/MechanicalClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/MechanicalClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)
	
	_register_upgrade_ui(
		"pendulumclock",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/PendulumClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/PendulumClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)
	
	_register_upgrade_ui(
		"pocketwatch",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/PocketWatchUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/PocketWatchUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)
	
	_register_upgrade_ui(
		"modernclock",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/ModernClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/ModernClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)
	
	_register_upgrade_ui(
		"digitalclock",
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/DigitalClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/DigitalClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton
	)

	# Create upgrades (effects live here, data lives in Upgrade objects)
	upgrades["sun"] = Upgrade.new(
		"sun",
		"Click Power +1 seconds",
		60,
		1.15,
		func(ctx): ctx["main"].click += 1
	)

	upgrades["obelisk"] = Upgrade.new(
		"obelisk",
		"Click Power +10 seconds",
		3599,
		1.15,
		func(ctx): ctx["main"].click += 10
	)
	
	upgrades["sundial"] = Upgrade.new(
		"sundial",
		"Click Power +1 minute",
		21594,
		1.15,
		func(ctx): ctx["main"].click += 60
	)

	upgrades["waterclock"] = Upgrade.new(
		"waterclock",
		"Click Power + 10 minutes",
		215950,
		1.15,
		func(ctx): ctx["main"].click += 600
	)
	
	upgrades["candleclock"] = Upgrade.new(
		"candleclock",
		"Click Power + 30 minutes",
		647820,
		1.15,
		func(ctx): ctx["main"].click += 1800
	)
	
	upgrades["hourglass"] = Upgrade.new(
		"hourglass",
		"Click Power + 45 minutes",
		971730,
		1.15,
		func(ctx): ctx["main"].click += 2700
	)
	
	upgrades["mechanicalclock"] = Upgrade.new(
		"mechanicalclock",
		"Click Power + 1 hour",
		11457595,
		1.15,
		func(ctx): ctx["main"].click += 3600
	)
	
	upgrades["pendulumclock"] = Upgrade.new(
		"pendulumclock",
		"Click Power + 10 hours",
		14575950,
		1.15,
		func(ctx): ctx["main"].click += 36000
	)
	
	upgrades["pocketwatch"] = Upgrade.new(
		"pocketwatch",
		"Click Power + 1 day",
		36439875,
		1.15,
		func(ctx): ctx["main"].click += 86400
	)
	
	upgrades["modernclock"] = Upgrade.new(
		"modernclock",
		"Click Power + 1 week",
		255079125,
		1.15,
		func(ctx): ctx["main"].click += 604800
	)
	
	upgrades["digitalclock"] = Upgrade.new(
		"digitalclock",
		"Click Power + 2.5 weeks",
		637697813,
		1.15,
		func(ctx): ctx["main"].click += 1512000
	)

	_update_ui()

# this function is used for every upgrade
func _register_upgrade_ui(id: String, title_node: Label, button_node: Button) -> void:
	upgrade_ui[id] = {"title": title_node, "button": button_node}
	button_node.pressed.connect(func(): _on_upgrade_buy_pressed(id))

#this function handles every upgrade cost logic
func _on_upgrade_buy_pressed(id: String) -> void:
	var up: Upgrade = upgrades[id]
	var before_click := click
	
	total_time = up.buy(total_time, {"main": self})
	
	# If click increased, do the rewind burst then update speed
	if click != before_click:
		earth_spinner.reverse_spin_burst()
		cloud_spinner.reverse_spin_burst()
		earth_spinner.set_click_rate(click)
		cloud_spinner.set_click_rate(click)
		
	_update_ui()

# this function handles the flashing updating UI for clicking button
func _on_clock_button_pressed() -> void:
	_flash_button()
	total_time += click
	_update_ui()

# this function flashes the click button when clicked
func _flash_button() -> void:
	clock_button.modulate = Color(1.5, 1.5, 1.5, 1.0)
	var tween := create_tween()
	tween.tween_property(clock_button, "modulate", Color(1, 1, 1, 1), 0.12)

# this function updates TimeCountLabel
func _get_time_label(total_time_int: int) -> String:
	var total_seconds := int(total_time_int)

	if total_seconds < 60:
		return "%d seconds" % total_seconds
	elif total_seconds < 60 * 60:
		var minutes := total_seconds / 60
		var seconds := total_seconds % 60
		return "%d minutes, %d seconds" % [minutes, seconds]
	elif total_seconds < 60 * 60 * 24:
		var hours := total_seconds / 3600
		var minutes := (total_seconds % 3600) / 60
		var seconds := total_seconds % 60
		return "%d hours, %d minutes, %d seconds" % [hours, minutes, seconds]
	else:
		var days := total_seconds / 86400
		var hours := (total_seconds % 86400) / 3600
		var minutes := (total_seconds % 3600) / 60
		var seconds := total_seconds % 60
		return "%d days, %d hours, %d minutes, %d seconds" % [days, hours, minutes, seconds]

# this function updates the rate ratio
func _get_rate_ratio(value: int) -> float:
	#seconds
	if value < 60:
		return value
	#minutes
	elif value >= 60 and value < 3600:
		return value / 60.0
	#hours
	elif value >= 3600 and value <86400:
		return value / 3600.0
	#days
	elif value >= 86400 and value < 604800:
		return value / 86400.0
	#weeks
	elif value >= 604800 and value < 2629800:
		return value / 604800.0
	#months
	elif value >= 2629800 and value < 31557600:
		return value / 2629800.0
	#years
	else:
		return value/31557600.0

# this function updates the rate labels
func _get_rate_label(value: int) -> String:
	#seconds
	if value < 60:
		return "(seconds)"
	#minutes
	if value >= 60 and value < 3600:
		return "(minutes)"
	#hours
	elif value >= 3600 and value <86400:
		return "(hours)"
	#days
	elif value >= 86400 and value < 604800:
		return "(days)"
	#weeks
	elif value >= 604800 and value < 2629800:
		return "(weeks)"
	#months
	elif value >= 2629800 and value < 31557600:
		return "(months)"
	#years
	else:
		return "(years)"

# this function updates the UI
func _update_ui() -> void:
	time_label.text = "Time: " + _get_time_label(int(total_time))
	rate_label.text = "Rate: %.2f%s per click" % [_get_rate_ratio(int(click)), _get_rate_label(int(click))]

	# Update every upgrade card using the same loop
	for id in upgrades.keys():
		var up: Upgrade = upgrades[id]
		var cost := up.get_cost()

		var title_node: Label = upgrade_ui[id]["title"]
		var button_node: Button = upgrade_ui[id]["button"]

		title_node.text = "                %s (Lvl %d)\n   Cost: %.2f%s" % [
			up.title,
			up.level,
			_get_rate_ratio(cost),
			_get_rate_label(cost)
		]

		button_node.disabled = total_time < cost
	
