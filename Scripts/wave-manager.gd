
class_name WaveManager

const WAVE_MULTIPLIER = 20

var current_wave_num = 1
var current_killed = 0
var waiting: bool = false
var total = 0

func initialize():
	self.total_enemies_for_wave()

func next_wave():
	self.waiting = false
	self.current_killed = 0
	self.current_wave_num += 1
	self.total_enemies_for_wave()

func get_active_enemy_count() -> int:
	# based on the wave we want a specific amount of enemies active at once
	return self.current_wave_num * self.WAVE_MULTIPLIER
	
func get_wave_number() -> int:
	return self.current_wave_num

func total_enemies_for_wave() -> int:
	self.total = self.get_active_enemy_count() * 2
	return self.total
	
func increment_killed():
	self.current_killed += 1

func get_remaining() -> int:
	return self.total - self.current_killed
