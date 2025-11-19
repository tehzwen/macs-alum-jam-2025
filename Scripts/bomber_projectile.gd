extends DirectionalProjectile

class_name BomberProjectile

var projectile_explosion_sound: AudioStreamPlayer2D

func initialize():
	$AnimatedSprite2D.play("default")
	projectile_explosion_sound = get_node("ExplosionSound")
	self.speed = 3.0
	self.damage = 5.0
	self.max_distance = 250
	super.initialize()
	
func on_max_distance_reached():
	projectile_explosion_sound.play()

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var plant_script: Plant = area.get_parent()
	plant_script.take_damage(self.damage)
	self.hide()
	self.speed = 0
	projectile_explosion_sound.play()

func _on_explosion_sound_finished() -> void:
	queue_free()
