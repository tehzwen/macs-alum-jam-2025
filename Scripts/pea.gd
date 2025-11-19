extends DirectionalProjectile

class_name Pea

func _ready() -> void:
	self.speed = 3.0
	self.damage = 25
	self.max_distance = 1000
	super.initialize()

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	# deal the damage to the bug, despawn, make noise
	var bug_script: Bug = area.get_parent()
	bug_script.take_damage(self.damage)
	queue_free()
