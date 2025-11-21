extends Node2D

class_name VineProjectile

var damage: float = 5.0
var stun_duration: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_aoe_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var objects = $AoeArea.get_overlapping_areas()
	$AoeArea.queue_free()
	for i in range(len(objects)):
		var bug_node = objects[i].get_parent()
		if (is_instance_valid(bug_node)):
			var bug_script: Bug = bug_node
			bug_script.be_stunned(self.stun_duration)
			bug_script.take_damage(self.damage)
