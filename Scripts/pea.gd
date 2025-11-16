extends Node2D

class_name Pea
@export var speed: float = 3.0
@export var damage: float = 25
@export var max_distance: float = 1000 

var direction: Vector2
var distance_travelled: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += self.direction * self.speed
	self.distance_travelled += self.speed
	
	if (self.distance_travelled > self.max_distance):
		queue_free()

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	# deal the damage to the bug, despawn, make noise
	var bug_script: Bug = area.get_parent()
	bug_script.take_damage(self.damage)
	queue_free()
