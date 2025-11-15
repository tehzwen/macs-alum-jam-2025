extends Plant

const tomato_projectile_scene: PackedScene = preload("res://Scenes/tomato.tscn")

func initialize():
	super.initialize()
	self.attack_cooldown = 0.5
	print("im a tomato plant!")

func attack():
	if (self.current_target == null):
		return
	# spawn in a tomato and send it toward the bug
	var direction = (self.current_target.position - self.position).normalized()
	var projectile = tomato_projectile_scene.instantiate()
	# get the tomato script and feed it the direction it's meant to go in
	var tomato_script: Tomato = projectile
	tomato_script.direction = direction
	add_child(projectile)
