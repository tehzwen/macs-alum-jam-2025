extends Node

var game_speed = 1.0
var cash: int = 0
var kills: int = 0

signal game_speed_change(speed: float)

func _ready() -> void:
	GameSignals.connect("cash_changed", Callable(self, "_on_cash_changed"))
	GameSignals.connect("kill_count_changed", Callable(self, "_on_kill_count_changed"))

func get_plant_cost(type: Manager.PLANT_TYPE) -> int:
	if type == Manager.PLANT_TYPE.PEA:
		return 25
	elif type == Manager.PLANT_TYPE.TOMATO:
		return 50
	elif type == Manager.PLANT_TYPE.FLY_TRAP:
		return 75
	elif type == Manager.PLANT_TYPE.VINE:
		return 100
	return 0

func set_game_speed(speed: float):
	if (speed <= 0):
		return
	self.game_speed = speed
	game_speed_change.emit(self.game_speed)

func reset():
	self.game_speed = 1.0
	self.cash = 0
	self.kills = 0
	game_speed_change.emit(self.game_speed)

func get_cash() -> int:
	return self.cash
	
func get_kills() -> int:
	return self.kills

func _on_cash_changed(amount: int):
	self.cash += amount
	
func _on_kill_count_changed(amount: int):
	self.kills += amount
