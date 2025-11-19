extends Node

var game_speed = 1.0

signal game_speed_change(speed: float)

func set_game_speed(speed: float):
	if (speed <= 0):
		return
	self.game_speed = speed
	game_speed_change.emit(self.game_speed)

func reset():
	self.game_speed = 1.0
	game_speed_change.emit(self.game_speed)
