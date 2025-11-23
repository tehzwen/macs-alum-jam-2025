extends Plant

class_name PeaPlant

const pea_projectile_scene: PackedScene = preload("res://Scenes/pea.tscn")

var pea_attack_sound: AudioStreamPlayer2D

func _ready() -> void:
	pea_attack_sound = get_node("AttackSound")

func initialize():
	self.attack_cooldown = 0.50
	self.attack_duration = 0.1
	super.initialize()
	$AnimatedSprite2D.play("default")

func attack():
	super.attack()
	if (self.current_target == null):
		return
	# spawn in a tomato and send it toward the bug
	var direction = (self.current_target.position - self.position).normalized()
	var projectile = pea_projectile_scene.instantiate()
	pea_attack_sound.play()
	# get the tomato script and feed it the direction it's meant to go in
	var pea_script: Pea = projectile
	pea_script.direction = direction
	add_child(projectile)

func _on_vision_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes[area_rid.get_id()] = area.get_parent()

func _on_vision_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes.erase(area_rid.get_id())
