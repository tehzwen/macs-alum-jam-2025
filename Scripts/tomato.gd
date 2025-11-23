extends DirectionalProjectile

class_name Tomato

var tomato_splash_sound: AudioStreamPlayer2D

func initialize():
	tomato_splash_sound = get_node("TomatoSplashSound")
	self.speed = 2.5
	self.damage = 50
	self.max_distance = 500
	super.initialize()

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if not self.visible:
		return
		
	# apply main damage to the hit target
	var main_hit: Bug = area.get_parent()
	main_hit.take_damage(self.damage)
		
	var bodies = $AoeArea.get_overlapping_areas()
	for body in bodies:
		var bug_script: Bug = body.get_parent()
		bug_script.take_damage(self.damage/2) # reduced aoe damage
	
	tomato_splash_sound.play()
	self.visible = false
	self.speed = 0

# signal frees the tomato after the sound is played
func _on_tomato_splash_sound_finished() -> void:
	queue_free()
