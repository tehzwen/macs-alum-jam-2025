extends Plant

class_name PeaPlant

const pea_projectile_scene: PackedScene = preload("res://Scenes/pea.tscn")

func initialize():
	super.initialize()
	self.attack_cooldown = 0.5
	self.range = 500
	print("im a pea plant!")

func attack():
	if (self.current_target == null):
		return
	# spawn in a tomato and send it toward the bug
	var direction = (self.current_target.position - self.position).normalized()
	var projectile = pea_projectile_scene.instantiate()
	# get the tomato script and feed it the direction it's meant to go in
	var pea_script: Pea = projectile
	pea_script.direction = direction
	add_child(projectile)
