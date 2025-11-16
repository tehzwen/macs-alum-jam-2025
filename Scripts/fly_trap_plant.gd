extends Plant

class_name FlyTrapPlant


const fly_trap_projectile_scene: PackedScene = preload("res://Scenes/fly-trap-projectile.tscn")

var spawned_bite_attack: bool = false
var bite_attack: FlyTrapProjectile

func initialize():
	super.initialize()
	self.attack_cooldown = 0.5
	self.range = 150
	self.total_hp = 500
	self.grid_height = 2
	self.grid_width = 2
	print("im a fly trap plant!")
	$AnimatedSprite2D.play("default")

func set_target(target: Node2D):
	super.set_target(target)
	self.spawned_bite_attack = false

func attack():
	super.attack()
	if (self.current_target == null):
		return
	if (!self.spawned_bite_attack):
		# spawn in a tomato and send it toward the bug
		var projectile = fly_trap_projectile_scene.instantiate()
		self.current_target.add_child(projectile)
		self.spawned_bite_attack = true
		self.bite_attack = projectile
		
	var bug_script: Bug = self.current_target
	bug_script.take_damage(self.bite_attack.damage)
