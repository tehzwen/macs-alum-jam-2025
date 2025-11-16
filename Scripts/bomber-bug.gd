extends Bug

class_name BomberBug

const bomber_bug_projectile_scene: PackedScene = preload("res://Scenes/bomber-projectile.tscn")
@export var range: float = 200

var projectile_node: Node2D
var projectile_sprite: Sprite2D
var attack_started: bool = false
var walk_started: bool = false

func attack():
	super.attack()
	self.walk_started = false
	var inst = bomber_bug_projectile_scene.instantiate()
	add_child(inst)
	
	if (not self.attack_started):
		$Sprite.play("attack")
		self.attack_started = true
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
	self.attack_started = false
	if (self.reached_target == null):
		if (not self.walk_started):
			$Sprite.play("default")
			self.walk_started = true
		if (self.projectile_node != null):
			self.projectile_node.queue_free()
			self.projectile_node = null
		var direction = (self.target.position - self.position).normalized()
		self.position += direction * self.move_speed
		
		if (self.range >= self.position.distance_to(self.target.position)):
			self.reached_target = self.target
		self.attack_started = false
	else:
		if (not self.attack_started):
			$Sprite.play("attack")
			self.attack_started = true

func _on_vision_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes[area_rid.get_id()] = area.get_parent()

func _on_vision_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes.erase(area_rid.get_id())
