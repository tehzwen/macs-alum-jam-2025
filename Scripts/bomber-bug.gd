extends Bug

class_name BomberBug

const bomber_bug_projectile_scene: PackedScene = preload("res://Scenes/bomber-projectile.tscn")
@export var range: float = 200

func attack():
	super.attack()
	
	print("i'd be attacking now!")
	var inst = bomber_bug_projectile_scene.instantiate()
	add_child(inst)
	
	var direction = (self.reached_target.position - self.position).normalized()
	var inst_node: Node2D = inst
	inst_node.look_at(direction)
	inst_node.translate(direction * range/2)
	sprite = inst_node.get_node("Sprite")
	sprite.set_instance_shader_parameter("attack_timer", self.attack_timer)
	
	var plant_script: Plant = self.reached_target
	plant_script.take_damage(self.damage)
	
	
func initialize(id: String) -> void:
	super.initialize(id)
	self.damage = 0.1
	self.attack_cooldown = 1.0
	
func move_to_target():
	super.move_to_target()
	if (self.reached_target == null):
		var direction = (self.target.position - self.position).normalized()
		self.position += direction * self.move_speed
		
		if (self.range >= self.position.distance_to(self.target.position)):
			self.reached_target = self.target
	
