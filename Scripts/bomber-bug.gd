extends Bug

class_name BomberBug

var attack_audio_stream: AudioStreamPlayer2D

const bomber_bug_projectile_scene: PackedScene = preload("res://Scenes/bomber-projectile.tscn")
@export var range: float = 150

var projectile_node: Node2D
var projectile_sprite: Sprite2D

func _ready() -> void:
	attack_audio_stream = get_node("AttackSound")

func attack():
	super.attack()
	var inst = bomber_bug_projectile_scene.instantiate()
	add_child(inst)
	
	attack_audio_stream.play()
	self.set_animation("attack")
	var direction = (self.reached_target.position - self.position).normalized()
	projectile_node = inst
	projectile_node.look_at(self.reached_target.position)
	projectile_node.position = $ShooterMarker.position
	var projectile_script: BomberProjectile = projectile_node
	projectile_script.direction = direction
	
func initialize(id: String) -> void:
	self.damage = 10
	self.coin_worth = 4
	self.attack_cooldown = 1.25
	self.total_hp = 75
	super.initialize(id)
	
func move_to_target():
	super.move_to_target()
	if (self.reached_target == null):
		self.set_animation("default")
		if (self.projectile_node != null):
			self.projectile_node.queue_free()
			self.projectile_node = null
		var direction = (self.target.position - self.position).normalized()
		self.position += direction * self.move_speed
		
		if (self.range >= self.position.distance_to(self.target.position)):
			self.reached_target = self.target
	else:
		self.set_animation("attack")

func _on_vision_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes[area_rid.get_id()] = area.get_parent()

func _on_vision_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes.erase(area_rid.get_id())
