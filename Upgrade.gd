class_name Upgrade
extends Node

var id: String
var title: String
var base_cost: int
var growth: float
var level: int = 0
var apply_effect: Callable

# Called when the upgrade is initialized for the first time
func _init(_id: String, _title: String, _base_cost: int, _growth: float, _apply_effect: Callable) -> void:
	id = _id
	title = _title
	base_cost = _base_cost
	growth = _growth
	apply_effect = _apply_effect

#returns the cost of the upgrade
func get_cost() -> int:
	var cost_f := float(base_cost) * pow(growth, float(level))
	return int(ceil(cost_f))
	
# reutrns true if play can buy upgrade
func can_buy(currency: int, ctx: Dictionary) -> int:
	return currency >= get_cost()
	
func buy(currency: int, ctx: Dictionary) -> int:
	var cost := get_cost()
	var can_buy := can_buy(currency, ctx)
	if not can_buy:
		return cost
	currency -= cost
	level += 1
	apply_effect.call(ctx)
	return currency
	
