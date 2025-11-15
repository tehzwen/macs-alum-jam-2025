extends Node2D

class_name Tomato

@export var speed: float = 1.0
@export var damage: float = 40.0
var direction: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position += self.direction * self.speed

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("hit area %s" % area.get_parent().to_string())
	# deal the damage to the bug, despawn, make noise
	var bug_script: Bug = area.get_parent()
	bug_script.take_damage(self.damage)
	queue_free()
