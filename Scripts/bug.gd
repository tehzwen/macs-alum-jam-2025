extends Node2D

class_name Bug

var id: String
var max_hp: float = 50
var total_hp: float = 50
var damage: float = 0.5
var target: Node2D
var move_speed: float = 0.5
var attack_cooldown = 0.5
var attack_timer = 0.0
var reached_target: Node2D
var sprite: Sprite2D

func initialize(id: String) -> void:
	self.id = id
	sprite = self.get_node("Sprite")
	sprite.set_instance_shader_parameter("health_percentage", 1.0)
	print("me a bug with id of %s" % id)

func get_id():
	return self.id

func set_target(target: Node2D):
	self.target = target
	#if (target != null):
		#print("my target is now " + target.to_string())
	
func take_damage(damage: float):
	if (self.total_hp > 0):
		self.total_hp -= damage
	print("I have %d hp left" % self.total_hp)
	var health_percentage = self.total_hp / self.max_hp
	sprite.set_instance_shader_parameter("health_percentage", health_percentage)

func get_target() -> Node2D:
	return self.target
	
func attack():
	var plant_script: Plant = self.reached_target
	if plant_script.total_hp <= 0:
		self.set_target(null)
		return
	
func move_to_target():
	pass
	
func die():
	queue_free()

func _process(delta: float) -> void:
	if (self.reached_target != null):
		self.attack_timer -= delta
		if (self.attack_timer <= 0.0):
			self.attack_timer = self.attack_cooldown
			self.attack()
