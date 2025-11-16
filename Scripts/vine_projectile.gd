extends Node2D

class_name VineProjectile

var damage: float = 0.5
var stun_duration: int = 5
var aoe_bodies: Array[Bug] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_aoe_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.aoe_bodies.push_back(area.get_parent())

func _process(delta: float) -> void:
	# loop over the aoe bugs & set speed to zero
	for i in range(len(self.aoe_bodies)):
		var bug_node = self.aoe_bodies[i]
		if (is_instance_valid(bug_node)):
			bug_node.move_speed = 0.0
