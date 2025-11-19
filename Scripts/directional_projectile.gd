extends Node2D

class_name DirectionalProjectile

var direction: Vector2
var speed: float
var original_speed: float
var distance_travelled: float
var max_distance: float
var damage: float

func apply_globals(game_speed: float):
	self.speed = self.original_speed * game_speed

func _on_global_game_speed_change(speed: float):
	self.apply_globals(speed)
	
func on_max_distance_reached():
	queue_free()

func initialize():
	self.max_distance = 1000
	self.distance_travelled = 0
	self.original_speed = self.speed
	Globals.game_speed_change.connect(self._on_global_game_speed_change)
	self.apply_globals(Globals.game_speed)
	
func set_invisible():
	self.visible = false
	
func _ready() -> void:
	self.initialize()

func _process(delta: float) -> void:
	self.position += self.direction * self.speed
	self.distance_travelled += self.speed
	
	if (self.distance_travelled > self.max_distance):
		self.on_max_distance_reached()
