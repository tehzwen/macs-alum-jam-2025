extends Node2D

class_name Plant

@export var grid_width = 1
@export var grid_height = 1

var total_hp: int = 100
var range: float = 250.0
var current_target: Node2D = null
var attack_cooldown: float
var attack_timer = 0.0

func initialize():
	print("im a plant!")

func attack():
	print("i am attacking bug with id of: " + self.current_target.get_id())

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

func _process(delta: float) -> void:
	if (self.current_target != null):
		self.attack_timer -= delta
		if (self.attack_timer <= 0.0):
			self.attack_timer = self.attack_cooldown
			self.attack()
