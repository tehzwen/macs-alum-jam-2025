extends Node

signal kill_count_changed(count)
signal cash_changed(amount)
signal seeds_changed(amount)
signal wave_changed(amount)
signal timer_changed(amount)

# Signal emitter functions
#func update_health(amount: int) -> void:
	#emit_signal("health_changed", amount)

func update_kill_count(count: int) -> void:
	emit_signal("kill_count_changed", count)

func update_cash(amount: int) -> void:
	emit_signal("cash_changed", amount)

func update_seeds(amount: int) -> void:
	emit_signal("seeds_changed", amount)
	
func update_wave(amount: int) -> void:
	emit_signal("wave_changed", amount)
	
func update_timer(new_value: int) -> void:
	emit_signal("timer_changed", new_value)
