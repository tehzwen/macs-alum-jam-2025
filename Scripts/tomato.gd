extends Node2D

class_name Tomato

@export var speed: float = 1.0
@export var damage: float = 25
@export var max_distance: float = 1000 

var direction: Vector2
var distance_travelled: float = 0
var aoe_targets = {}

func _process(delta: float) -> void:
	self.position += self.direction * self.speed
	self.distance_travelled += self.speed
	
	if (self.distance_travelled > self.max_distance):
		queue_free()

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	for key in self.aoe_targets:
		var bug_script: Bug = self.aoe_targets[key]
		bug_script.take_damage(self.damage)
	
	queue_free()

func _on_aoe_area_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.aoe_targets[area_rid.get_id()] = area.get_parent()

func _on_aoe_area_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.aoe_targets.erase(area_rid.get_id())
