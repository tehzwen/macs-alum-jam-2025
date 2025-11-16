extends Node2D

class_name Bug

var id: String
var max_hp: float
var total_hp: float = 50
var damage: float = 0.5
var target: Node2D
var move_speed: float = 0.5
var original_move_speed: float
var attack_cooldown = 0.5
var attack_timer = 0.0
var reached_target: Node2D
var sprite: AnimatedSprite2D

func initialize(id: String) -> void:
	self.max_hp = self.total_hp
	self.id = id
	self.original_move_speed = self.move_speed
	sprite = self.get_node("Sprite")
	sprite.set_instance_shader_parameter("health_percentage", 1.0)
	sprite.play("default")

func get_id():
	return self.id

func set_target(target: Node2D):
	self.target = target
	
func take_damage(damage: float):
	if (self.total_hp > 0):
		self.total_hp -= damage
	var health_percentage = self.total_hp / self.max_hp
	
	if (sprite != null):
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
		#self.sprite.stop()
		self.attack_timer -= delta
		if (self.attack_timer <= 0.0):
			self.attack_timer = self.attack_cooldown
			self.attack()
