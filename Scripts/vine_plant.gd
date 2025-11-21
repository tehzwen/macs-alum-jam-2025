extends Plant

const vine_projectile_scene: PackedScene = preload("res://Scenes/vine-projectile.tscn")

var death_sound: AudioStreamPlayer2D
var attack_sound: AudioStreamPlayer2D

var instantiated_vines = []

func _ready() -> void:
	death_sound = get_node("DeathSound")
	attack_sound = get_node("AttackSound")

func initialize():
	self.attack_cooldown = 1.0
	self.attack_duration = 3
	super.initialize()
	print("im a vine plant!")
	$AnimatedSprite2D.play("default")
	
func die():
	for i in range(len(self.instantiated_vines)):
		var vine = self.instantiated_vines[i]
		if (is_instance_valid(vine)):
			vine.queue_free()

	death_sound.play()
	super.die()
	
func stop_attack():
	super.stop_attack()
	
	for i in range(len(self.instantiated_vines)):
		var vine = self.instantiated_vines[i]
		if (is_instance_valid(vine)):
			vine.queue_free()
	self.instantiated_vines = []

func attack():
	super.attack()
	attack_sound.play()
	if (self.current_target == null):
		return
	
	var projectile = vine_projectile_scene.instantiate()
	self.current_target.add_child(projectile)
	self.instantiated_vines.push_back(projectile)


func _on_vision_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes[area_rid.get_id()] = area.get_parent()

func _on_vision_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes.erase(area_rid.get_id())
