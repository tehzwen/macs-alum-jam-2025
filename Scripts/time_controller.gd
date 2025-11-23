extends Node2D

## Time (in seconds) for each wave
@export var wave_interval: float = 30.0

# Internal countdown timer
var current_time: int

# Timer update rate
var tick_rate: float = 1.0

# Variable to hold delta between ticks
var accumulator: float = 0.0

@onready var manager = get_node('../Spawner')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_time = wave_interval
	accumulator = 0.0
	#set_process(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	accumulator += delta
	
	# Only update when a full time tick has completed
	if accumulator >= tick_rate:
		accumulator -= tick_rate
		current_time -= tick_rate
	
		GameSignals.update_timer(current_time)
	
		if current_time <= 0:
			#GameSignals.wave_changed(1) #being handled in manager.gd
			current_time = wave_interval # reset for next wave
