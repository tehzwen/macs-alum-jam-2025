extends Bug

class_name Ant

var attack_started: bool = false


func initialize(id: String) -> void:
	super.initialize(id)
	self.damage = 0.1
	self.move_speed = 1
	
func get_id():
	return self.id + ", but im an ant"
	
func move_to_target():
	super.move_to_target()
	if (self.reached_target == null):
		var direction = (self.target.position - self.position).normalized()
		self.position += direction * self.move_speed

func attack():
	super.attack()
	# if we reached the plant, just deal damage to it
	if (self.reached_target != null):
		var plant_script: Plant = self.reached_target
		plant_script.take_damage(self.damage)
		
		if (not self.attack_started):
			$Sprite.play("attack")
			self.attack_started = true
	else:
		self.attack_started = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (self.reached_target == null):
		self.reached_target = area.get_parent()
	
