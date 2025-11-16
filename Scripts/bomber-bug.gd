extends Bug

class_name BomberBug

const bomber_bug_projectile_scene: PackedScene = preload("res://Scenes/bomber-projectile.tscn")
@export var range: float = 200

var projectile_node: Node2D
var projectile_sprite: Sprite2D
var attack_started: bool = false

func attack():
	super.attack()
	var inst = bomber_bug_projectile_scene.instantiate()
	add_child(inst)
	
	var direction = (self.reached_target.position - self.position).normalized()
	projectile_node = inst
	projectile_node.look_at(self.reached_target.position)
	projectile_node.position = $ShooterMarker.position
	var projectile_script: BomberProjectile = projectile_node
	projectile_script.direction = direction
	
	
func initialize(id: String) -> void:
	super.initialize(id)
	self.damage = 10
	self.attack_cooldown = 1.0
	
func move_to_target():
	super.move_to_target()
	if (self.reached_target == null):
		self.attack_started = false
		if (self.projectile_node != null):
			self.projectile_node.queue_free()
			self.projectile_node = null
		var direction = (self.target.position - self.position).normalized()
		self.position += direction * self.move_speed
		
		if (self.range >= self.position.distance_to(self.target.position)):
			self.reached_target = self.target
	else:
		if (not self.attack_started):
			$Sprite.play("attack")
			self.attack_started = true
		
	
