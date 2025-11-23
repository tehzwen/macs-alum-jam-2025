extends Node2D

class_name Plant

@export var grid_width = 1
@export var grid_height = 1

var total_hp: float = 100
var max_hp: float
var range: float = 250.0
var current_target: Node2D = null
var attack_cooldown: float
var attack_timer = 0.0
var original_attack_cooldown 
var attack_audio_stream: AudioStreamPlayer2D
var attack_duration = 1.0
var original_attack_duration
var attack_duration_timer = 0.0
var grid_position: Vector2
var is_attacking: bool = false
var seen_nodes = {}

func apply_globals(game_speed: float):
	self.attack_duration = self.original_attack_duration / game_speed
	self.attack_cooldown = self.original_attack_cooldown / game_speed

func _on_global_game_speed_change(speed: float):
	self.apply_globals(speed)

func initialize():
	print("im a plant!")
	self.original_attack_cooldown = self.attack_cooldown
	self.original_attack_duration = self.attack_duration
	self.max_hp = self.total_hp
	Globals.game_speed_change.connect(self._on_global_game_speed_change)

func attack():
	return

func take_damage(damage: float):
	$HealthBar.set_instance_shader_parameter("health_percentage", self.total_hp/self.max_hp)
	if (self.total_hp > 0):
		self.total_hp -= damage
	
func set_target(target: Node2D):
	if (target != null):
		self.current_target = target
		
func get_dimensions() -> Vector2:
	return Vector2(self.grid_width, self.grid_height)

func die():
	queue_free()

func stop_attack():
	pass
	
func distance_sort(a: Node2D, b: Node2D):
	var a_distance = self.position.distance_to(a.position)
	var b_distance = self.position.distance_to(b.position)
	
	if (a_distance < b_distance):
		return true
	elif (a_distance == b_distance):
		return true
	else:
		return false

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
	else:
		var bugs = []
		for key in self.seen_nodes.keys():
			bugs.push_back(self.seen_nodes[key])
		bugs.sort_custom(Callable(self, "distance_sort"))
		if (len(bugs) > 0 and is_instance_valid(bugs[0])):
			self.set_target(bugs[0])
