extends Node2D

class_name Bug

var id: String
var max_hp: float
var total_hp: float = 50
var damage: float = 0.5
var target: Node2D
var move_speed: float = 0.5
var original_move_speed: float
var attack_cooldown = 0.5
var original_attack_cooldown
var attack_timer = 0.0
var stun_timer = 0.0
var reached_target: Node2D
var sprite: AnimatedSprite2D
var seen_nodes = {}

func apply_globals(game_speed: float):
	self.attack_cooldown = self.original_attack_cooldown / game_speed
	self.move_speed = self.original_move_speed * game_speed

func _on_global_game_speed_change(speed: float):
	self.apply_globals(speed)

func initialize(id: String) -> void:
	Globals.game_speed_change.connect(self._on_global_game_speed_change)
	self.max_hp = self.total_hp
	self.id = id
	self.original_move_speed = self.move_speed
	self.original_attack_cooldown = self.attack_cooldown
	
	# apply globals
	self.apply_globals(Globals.game_speed)
	sprite = self.get_node("Sprite")
	sprite.set_instance_shader_parameter("health_percentage", 1.0)
	self.set_animation("default")

func get_id():
	return self.id
	
func set_animation(animation: String):
	if sprite.animation == animation:
		return
	sprite.play(animation)
		
func set_target(target: Node2D):
	self.target = target
	
func take_damage(damage: float):
	if (self.total_hp > 0):
		self.total_hp -= damage
	var health_percentage = self.total_hp / self.max_hp
	
	if (sprite != null):
		sprite.set_instance_shader_parameter("health_percentage", health_percentage)

func get_target() -> Node2D:
	return self.target
	
func attack():
	var plant_script: Plant = self.reached_target
	if plant_script.total_hp <= 0:
		self.set_target(null)
		return
	
func move_to_target():
	pass
	
func die():
	GameSignals.update_kill_count(1)
	queue_free()

func be_stunned(timer: float):
	self.stun_timer = timer

func _process(delta: float) -> void:
	# if we are stunned, do nothing other than decrement the stun counter
	if self.stun_timer > 0.0:
		self.stun_timer -= delta
		return
	
	if (self.target != null and self.reached_target == null):
		self.move_to_target()
	elif (self.reached_target != null):
		self.attack_timer -= delta
		if (self.attack_timer <= 0.0):
			self.attack_timer = self.attack_cooldown
			self.attack()
	elif (self.target == null and self.reached_target == null):
		if (self.seen_nodes.size() > 0):
			# just pick something we've seen, prioritize plants
			for key in self.seen_nodes.keys():
				var seen = self.seen_nodes.get(key)
				
				if (seen is Plant):
					self.set_target(seen)
					break
				elif (seen is Bug):
					# check if our fellow bug is targetting a plant
					var bug_script: Bug = seen
					if (bug_script.target != null):
						self.set_target(bug_script.target)
		else:
			# TODO we need to give them some help
			pass
