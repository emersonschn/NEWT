# Upgrade.gd
class_name Upgrade
extends RefCounted
# (RefCounted is better than Node for pure data objects)

var id: String
var title: String
var base_cost: int
var growth: float
var level: int = 0
var apply_effect: Callable

# this function initilizes a object for each upgrade in the game
func _init(_id: String, _title: String, _base_cost: int, _growth: float, _apply_effect: Callable) -> void:
	id = _id
	title = _title
	base_cost = _base_cost
	growth = _growth
	apply_effect = _apply_effect

# this function returns the cost for an upgrade
func get_cost() -> int:
	var cost_f := float(base_cost) * pow(growth, float(level))
	return int(ceil(cost_f))

# this function lets the user know if they have enough for
# an upgrade
func can_buy(currency: float) -> bool:
	return currency >= get_cost()

# this function buys an upgrade and scales cost and applies
# game functionality effect
func buy(currency: float, ctx: Dictionary) -> float:
	var cost := get_cost()
	if currency < cost:
		return currency

	currency -= cost
	level += 1
	apply_effect.call(ctx)
	return currency
