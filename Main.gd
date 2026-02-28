# Main.gd
extends Node2D

var total_time: float = 0.0
var click: float = 1.0
var end_time: = 3155760000
var session_time: float = 0.0
var upgrade_cost_multiplier: float = 1.0 # normal prices
var autoclicker_cost_multiplier: float = 1.0 # normal prices

@onready var time_label: Label = $TimeCountLabel
@onready var clock_button: TextureButton = $ClockButton
@onready var rate_label: Label = $TimePerSecLabel
@onready var star_bonus_label: Label = $StarBonusLabel
@onready var earth_spinner := $EarthViewport/EarthWorld/EarthMesh
@onready var cloud_spinner := $EarthViewport/EarthWorld/CloudMesh
@onready var click_clock_sfx: AudioStreamPlayer = $Audio/ClickClockSFX
@onready var upgrade_purchase_sfx: AudioStreamPlayer = $Audio/UpgradePurchaseSFX
@onready var upgrades_panel: Control = $UpgradesUI/UpgradesPanel
@onready var upgrades_toggle: Button = $UpgradesUI/UpgradesMenuButton
@onready var autoclickers_panel: Control = $AutoclickerUI/AutoclickersPanel
@onready var autoclickers_toggle: Button = $AutoclickerUI/AutoclickersMenuButton

var _active_star_effect: String = ""
var _effect_timer: Timer
var star_bonus_cooldown: bool = false

# --- Upgrades data ---
var upgrades := {}        # id -> Upgrade
var upgrade_ui := {}      # id -> { "title": Label, "button": Button }
var autoclickers := {}     # id -> Autoclicker
var autoclicker_ui := {}     # id -> { "title": Label, "button": Button }

# this function initializes the start game
func _ready() -> void:

	clock_button.pressed.connect(_on_clock_button_pressed)
	earth_spinner.set_click_rate(click)
	cloud_spinner.set_click_rate(click)
	
	# make the upgrades menu invisible on start
	upgrades_panel.visible = false
	upgrades_toggle.pressed.connect(_on_upgrades_toggle_pressed)
	
	# make the autoclickers menu invisible on start
	autoclickers_panel.visible = false
	autoclickers_toggle.pressed.connect(_on_autoclickers_toggle_pressed)
	
	# this for the star buff/nerf randomizer
	randomize()
	_effect_timer=Timer.new()
	_effect_timer.one_shot = true
	add_child(_effect_timer)
	_effect_timer.timeout.connect(_clear_star_effect)


	_register_all_upgrades()
	_create_upgrades()
	_register_all_autoclickers()
	_create_autoclickers()

	_update_ui()

# this function registers all upgrades
func _register_all_upgrades() -> void:
	_register_upgrade_ui("sun", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("obelisk", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/ObeliskUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/ObeliskUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("sundial", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunDialUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/SunDialUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("waterclock", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/WaterClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/WaterClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("candleclock", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/CandleClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/CandleClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("hourglass", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/HourGlassUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/HourGlassUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("mechanicalclock", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/MechanicalClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/MechanicalClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("pendulumclock", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/PendulumClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/PendulumClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("pocketwatch", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/PocketWatchUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/PocketWatchUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("modernclock", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/ModernClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/ModernClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_upgrade_ui("digitalclock", $UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/DigitalClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$UpgradesUI/UpgradesPanel/MarginContainer/ScrollContainer/UpgradesList/DigitalClockUpgrade/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)
		
	_update_ui()

# this function registers all upgrades
func _register_all_autoclickers() -> void:
	_register_autoclicker_ui("sun", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/SunAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/SunAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("obelisk", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/ObeliskAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/ObeliskAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("sundial", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/SunDialAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/SunDialAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("waterclock", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/WaterClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/WaterClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("candleclock", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/CandleClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/CandleClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("hourglass", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/HourGlassAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/HourGlassAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("mechanicalclock", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/MechanicalClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/MechanicalClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("pendulumclock", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/PendulumClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/PendulumClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("pocketwatch", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/PocketWatchAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/PocketWatchAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("modernclock", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/ModernClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/ModernClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_register_autoclicker_ui("digitalclock", $AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/DigitalClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/Title,
		$AutoclickerUI/AutoclickersPanel/MarginContainer/ScrollContainer/UpgradesList/DigitalClockAutoclicker/MarginContainer/HBoxContainer/VBoxContainer/BuyButton)

	_update_ui()
	
# this function does stuff when the star is clicked
func apply_random_star_effect() -> void:
	# replace existing effect if one is active
	if _active_star_effect != "":
		_clear_star_effect()

	var roll := randi_range(2, 2)

	var increase : float = 0.0
	match roll:
		0:	# per click is multiplied by 2
			_active_star_effect = "double_click"
			click *= 2
			_start_effect_timer(10.0)
			star_bonus_label.text = "Star Bonus: Double rate per click for 10 seconds!"
			clear_star_bonus_label()

		1: # per click is multiplied by half
			_active_star_effect = "half_click"
			click = max(1, int(click / 2))
			_start_effect_timer(10.0)
			star_bonus_label.text = "Star Bonus: Half rate per click for 10 seconds!"
			clear_star_bonus_label()

		2: # this adds 20% of your total time to your total
			_active_star_effect = "bonus_time"
			increase = (total_time * .2)
			star_bonus_label.text = "Star Bonus: Total time bonus +%.2f %s!" % [_get_rate_ratio(increase), _get_rate_label(increase)]
			clear_star_bonus_label()
			
		3: # per click is multiplied by 3
			_active_star_effect = "triple_click"
			click *= 3
			_start_effect_timer(10.0)
			star_bonus_label.text = "Star Bonus: Triple rate per click for 10 seconds!"
			clear_star_bonus_label()
			
		4: # upgrades are half price
			_active_star_effect = "fire_sale"
			upgrade_cost_multiplier = .5
			_start_effect_timer(10.0)
			star_bonus_label.text = "Star Bonus: Fire Sale! Upgrades are 50% off for 10 seconds!"
			clear_star_bonus_label()
			
		5: # double total time increase
			_active_star_effect = "double_time"
			total_time *= 2
			star_bonus_label.text = "Star Bonus: Total time doubled!"
			clear_star_bonus_label()
			

	_update_ui()

# this is a helper function for apply_random_star_effect
func _start_effect_timer(seconds: float) -> void:
	_effect_timer.start(seconds)

# this is a helper function for apply_random_star_effect
func _clear_star_effect() -> void:
	match _active_star_effect:
		"double_click":
			click = int(click / 2)
		"half_click":
			click *= 2
		"bonus_time":
			pass
		"triple_click":
			click = int(click/3)
		"fire_sale":
			upgrade_cost_multiplier = 1
		"double_time":
			pass

	_active_star_effect = ""
	_update_ui()

# this function clears the StarBonusLabel after 10  seconds once its activated
func clear_star_bonus_label() -> void:
	await get_tree().create_timer(10.0).timeout
	star_bonus_label.text=""


# this function is used for every upgrade
func _register_upgrade_ui(id: String, title_node: Label, button_node: Button) -> void:
	upgrade_ui[id] = {"title": title_node, "button": button_node}
	button_node.pressed.connect(func(): _on_upgrade_buy_pressed(id))
	
# this function is used for every autoclicker
func _register_autoclicker_ui(id: String, title_node: Label, button_node: Button) -> void:
	autoclicker_ui[id] = {"title": title_node, "button": button_node}
	button_node.pressed.connect(func(): _on_autoclicker_buy_pressed(id))

# this function makes every upgrade
func _create_upgrades() -> void:

	upgrades["sun"] = Upgrade.new("sun","Click Power +1 seconds",60,1.15,func(ctx): ctx["main"].click += 1)
	upgrades["obelisk"] = Upgrade.new("obelisk","Click Power +10 seconds",3599,1.15,func(ctx): ctx["main"].click += 10)
	upgrades["sundial"] = Upgrade.new("sundial","Click Power +1 minute",21594,1.15,func(ctx): ctx["main"].click += 60)
	upgrades["waterclock"] = Upgrade.new("waterclock","Click Power +10 minutes",215950,1.15,func(ctx): ctx["main"].click += 600)
	upgrades["candleclock"] = Upgrade.new("candleclock","Click Power +30 minutes",647820,1.15,func(ctx): ctx["main"].click += 1800)
	upgrades["hourglass"] = Upgrade.new("hourglass","Click Power +45 minutes",971730,1.15,func(ctx): ctx["main"].click += 2700)
	upgrades["mechanicalclock"] = Upgrade.new("mechanicalclock","Click Power +1 hour",11457595,1.15,func(ctx): ctx["main"].click += 3600)
	upgrades["pendulumclock"] = Upgrade.new("pendulumclock","Click Power +10 hours",14575950,1.15,func(ctx): ctx["main"].click += 36000)
	upgrades["pocketwatch"] = Upgrade.new("pocketwatch","Click Power +1 day",36439875,1.15,func(ctx): ctx["main"].click += 86400)
	upgrades["modernclock"] = Upgrade.new("modernclock","Click Power +1 week",255079125,1.15,func(ctx): ctx["main"].click += 604800)
	upgrades["digitalclock"] = Upgrade.new("digitalclock","Click Power +2.5 weeks",637697813,1.15,func(ctx): ctx["main"].click += 1512000)

# this function makes every autoclicker
func _create_autoclickers() -> void:

	autoclickers["sun"] = Autoclicker.new("sun","Click Power +1 seconds",60,1.15,func(ctx): ctx["main"].click += 1)
	autoclickers["obelisk"] = Autoclicker.new("obelisk","Click Power +10 seconds",3599,1.15,func(ctx): ctx["main"].click += 10)
	autoclickers["sundial"] = Autoclicker.new("sundial","Click Power +1 minute",21594,1.15,func(ctx): ctx["main"].click += 60)
	autoclickers["waterclock"] = Autoclicker.new("waterclock","Click Power +10 minutes",215950,1.15,func(ctx): ctx["main"].click += 600)
	autoclickers["candleclock"] = Autoclicker.new("candleclock","Click Power +30 minutes",647820,1.15,func(ctx): ctx["main"].click += 1800)
	autoclickers["hourglass"] = Autoclicker.new("hourglass","Click Power +45 minutes",971730,1.15,func(ctx): ctx["main"].click += 2700)
	autoclickers["mechanicalclock"] = Autoclicker.new("mechanicalclock","Click Power +1 hour",11457595,1.15,func(ctx): ctx["main"].click += 3600)
	autoclickers["pendulumclock"] = Autoclicker.new("pendulumclock","Click Power +10 hours",14575950,1.15,func(ctx): ctx["main"].click += 36000)
	autoclickers["pocketwatch"] = Autoclicker.new("pocketwatch","Click Power +1 day",36439875,1.15,func(ctx): ctx["main"].click += 86400)
	autoclickers["modernclock"] = Autoclicker.new("modernclock","Click Power +1 week",255079125,1.15,func(ctx): ctx["main"].click += 604800)
	autoclickers["digitalclock"] = Autoclicker.new("digitalclock","Click Power +2.5 weeks",637697813,1.15,func(ctx): ctx["main"].click += 1512000)
	
# this function handles every upgrade cost logic
func _on_upgrade_buy_pressed(id: String) -> void:
	var up: Upgrade = upgrades[id]
	var before_click := click
	
	total_time = up.buy(total_time, {"main": self}, upgrade_cost_multiplier)
	
	# If click increased, do the rewind burst then update speed
	if click != before_click:
		earth_spinner.reverse_spin_burst()
		cloud_spinner.reverse_spin_burst()
		earth_spinner.set_click_rate(click)
		cloud_spinner.set_click_rate(click)
		
	upgrade_purchase_sfx.play()
	_update_ui()

# this function handles every upgrade cost logic
func _on_autoclicker_buy_pressed(id: String) -> void:
	var up: Autoclicker = autoclickers[id]
	var before_click := click
	
	total_time = up.buy(total_time, {"main": self}, upgrade_cost_multiplier)
	
	# If click increased, do the rewind burst then update speed
	if click != before_click:
		earth_spinner.reverse_spin_burst()
		cloud_spinner.reverse_spin_burst()
		earth_spinner.set_click_rate(click)
		cloud_spinner.set_click_rate(click)
		
	upgrade_purchase_sfx.play()
	_update_ui()
	
# this function handles the flashing updating UI for clicking button
func _on_clock_button_pressed() -> void:
	_flash_button()
	total_time += click
	click_clock_sfx.play()
	_update_ui()

# this function flashes the click button when clicked
func _flash_button() -> void:
	clock_button.modulate = Color(1.5, 1.5, 1.5, 1.0)
	var tween := create_tween()
	tween.tween_property(clock_button, "modulate", Color(1, 1, 1, 1), 0.12)

# this function updates TimeCountLabel
func _get_time_label(total_time_int: int) -> String:
	var total_seconds := total_time_int
	var times: Array[String] = []
	
	var years := total_seconds / 31557600
	total_seconds %= 31557600

	var months := total_seconds / 2629800
	total_seconds %= 2629800

	var weeks := total_seconds / 604800
	total_seconds %= 604800

	var days := total_seconds / 86400
	total_seconds %= 86400

	var hours := total_seconds / 3600
	total_seconds %= 3600

	var minutes := total_seconds / 60
	var seconds := total_seconds % 60

	# Add only non-zero values

	if years > 0:
		times.append("%d Year%s" % [years, "" if years == 1 else "s"])

	if months > 0:
		times.append("%d Month%s" % [months, "" if months == 1 else "s"])

	if weeks > 0:
		times.append("%d Week%s" % [weeks, "" if weeks == 1 else "s"])

	if days > 0:
		times.append("%d Day%s" % [days, "" if days == 1 else "s"])

	if hours > 0:
		times.append("%d Hour%s" % [hours, "" if hours == 1 else "s"])

	if minutes > 0:
		times.append("%d Minute%s" % [minutes, "" if minutes == 1 else "s"])

	if seconds > 0 or times.is_empty():
		times.append("%d Second%s" % [seconds, "" if seconds == 1 else "s"])

	return ", ".join(times)

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

func _end_game() -> void:
	
	# stop clicking
	clock_button.disabled = true
	
	# disable all upgrade buttons
	for id in upgrade_ui.keys():
		upgrade_ui[id]["button"].disabled = true
	
	# stop spinners if you want
	earth_spinner.set_click_rate(0)
	cloud_spinner.set_click_rate(0)

	time_label.text = "You reached the end of time."
	rate_label.text = "The universe rests."

# this function hides and opens the uppgrades menu when the 
# upgrades menu button is pressed
func _on_upgrades_toggle_pressed() -> void:
	upgrades_panel.visible = !upgrades_panel.visible
	autoclickers_panel.visible = false

# this function hides and opens the autoclickers menu when the 
# autoclickers menu button is pressed
func _on_autoclickers_toggle_pressed() -> void:
	autoclickers_panel.visible = !autoclickers_panel.visible
	upgrades_panel.visible = false

# this function updates the UI
func _update_ui() -> void:
	time_label.text = "Time: " + _get_time_label(int(total_time))
	rate_label.text = "Rate: %.2f%s per click" % [_get_rate_ratio(int(click)), _get_rate_label(int(click))]
	
	# Update every upgrade card using the same loop
	for id in upgrades.keys():
		var up: Upgrade = upgrades[id]
		var cost := up.get_cost(upgrade_cost_multiplier)

		var title_node: Label = upgrade_ui[id]["title"]
		var button_node: Button = upgrade_ui[id]["button"]

		title_node.text = "                %s (Lvl %d)\n   Cost: %.2f%s" % [
			up.title,
			up.level,
			_get_rate_ratio(cost),
			_get_rate_label(cost)
		]

		button_node.disabled = total_time < cost
	
func _process(delta: float) -> void:
	session_time += delta
