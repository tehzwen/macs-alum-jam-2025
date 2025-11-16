extends Bug

class_name Ant

var attack_audio_stream: AudioStreamPlayer2D

var attack_started: bool = false
var walk_started: bool = false

func initialize(id: String) -> void:
	super.initialize(id)
	self.damage = 0.1
	self.move_speed = 1
	
func _ready() -> void:
	attack_audio_stream = get_node("AttackSound")
	
func get_id():
	return self.id + ", but im an ant"
	
func move_to_target():
	super.move_to_target()
	self.attack_started = false
	if (self.reached_target == null):
		if (not self.walk_started):
			$Sprite.play("default")
			self.walk_started = true
		var direction = (self.target.position - self.position).normalized()
		self.position += direction * self.move_speed

func attack():
	super.attack()
	self.walk_started = false
	# if we reached the plant, just deal damage to it
	if (self.reached_target != null):
		var plant_script: Plant = self.reached_target
		plant_script.take_damage(self.damage)
		attack_audio_stream.play()
		
		if (not self.attack_started):
			$Sprite.play("attack")
			self.attack_started = true
	else:
		self.attack_started = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (self.reached_target == null):
		self.reached_target = area.get_parent()

func _on_vision_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes[area_rid.get_id()] = area.get_parent()	
	

func _on_vision_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	self.seen_nodes.erase(area_rid.get_id())
