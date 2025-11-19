extends Control

@onready var cash_label = $CanvasLayer/LabelPanel/GridContainer/CashLabel
@onready var seed_label = $CanvasLayer/LabelPanel/GridContainer/SeedsLabel
@onready var kill_label = $CanvasLayer/LabelPanel/GridContainer/KillsLabel
@onready var wave_label = $CanvasLayer/TimerPanel/GridContainer/WaveLabel
@onready var timer_label = $CanvasLayer/TimerPanel/GridContainer/NextWaveLabel

var cash: int = 0
var seeds: int = 0
var kills: int = 0
var wave: int = 1
var timer: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#GameSignals.connect()
	GameSignals.connect("kill_count_changed", Callable(self, "_on_kill_changed"))
	GameSignals.connect("cash_changed", Callable(self, "_on_cash_changed"))
	GameSignals.connect("seeds_changed", Callable(self, "_on_seeds_changed"))
	GameSignals.connect("wave_changed", Callable(self, "_on_wave_changed"))
	GameSignals.connect("timer_changed", Callable(self,"_on_timer_changed"))

# Adjust label by delta_value
func _on_kill_changed(delta_value: int) -> void:
	kills += delta_value
	kill_label.text = str(kills)

# Adjust label by delta_value
func _on_cash_changed(delta_value: int) -> void:
	cash += delta_value
	cash_label.text = str(cash)

# Adjust label by delta_value
func _on_seeds_changed(delta_value: int) -> void:
	seeds += delta_value
	seed_label.text = str(seeds)

func _on_wave_changed(delta_value: int) -> void:
	wave += delta_value
	wave_label.text = "Wave: " + str(wave)

func _on_timer_changed(new_value: int) -> void:
	timer = new_value
	timer_label.text = "Next: " + str(timer)
