extends Node2D

class_name Plant

@export var grid_width = 1
@export var grid_height = 1

var total_hp: int = 100
var range: float = 250.0
var current_target: Node2D = null
var attack_cooldown: float
var attack_timer = 0.0
var attack_audio_stream: AudioStreamPlayer2D
var attack_duration = 1.0
var attack_duration_timer = 0.0
var grid_position: Vector2
var is_attacking: bool = false

func _ready() -> void:
	self.attack_audio_stream = get_node('AudioStream')

func initialize():
	print("im a plant!")

func attack():
	self.attack_audio_stream.play()

func take_damage(damage: float):
	if (self.total_hp > 0):
		self.total_hp -= damage
	#print("I have %d hp left" % self.total_hp)
	
func set_target(target: Node2D):
	if (target != null):
		self.current_target = target
		
func get_dimensions() -> Vector2:
	return Vector2(self.grid_width, self.grid_height)

func die():
	queue_free()

func stop_attack():
	pass

func _process(delta: float) -> void:
	if self.current_target != null:
		if self.is_attacking:
			self.attack_duration_timer -= delta
			if self.attack_duration_timer <= 0.0:
				self.stop_attack()
				self.is_attacking = false
		else:
			self.attack_timer -= delta
			if self.attack_timer <= 0.0:
				self.attack()
				self.is_attacking = true
				self.attack_timer = self.attack_cooldown
				self.attack_duration_timer = self.attack_duration
