extends Plant

class_name TomatoPlant

const tomato_projectile_scene: PackedScene = preload("res://Scenes/tomato.tscn")

func initialize():
	self.attack_cooldown = 1.5
	super.initialize()
	print("im a tomato plant!")
	$AnimatedSprite2D.play("default")

func attack():
	super.attack()
	if (self.current_target == null):
		return
	# spawn in a tomato and send it toward the bug
	var direction = (self.current_target.position - self.position).normalized()
	var projectile = tomato_projectile_scene.instantiate()
	## get the tomato script and feed it the direction it's meant to go in
	var tomato_script: Tomato = projectile
	tomato_script.direction = direction
	add_child(projectile)

func _on_vision_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes[area_rid.get_id()] = area.get_parent()

func _on_vision_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes.erase(area_rid.get_id())
