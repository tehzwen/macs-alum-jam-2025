extends Node2D

const ant_scene: PackedScene = preload("res://Scenes/ant.tscn")
const bomber_scene: PackedScene = preload("res://Scenes/bomber-bug.tscn")
const tomato_plant_scene: PackedScene = preload("res://Scenes/tomato-plant.tscn")

var active_bugs = []
var active_plants = {}
var num_current_bugs = 0
var num_current_plants = 0
var current_round: int = 1
var wave_amount: int = 20
var rng = RandomNumberGenerator.new()

enum BUG_TYPE {
	ANT,
	BOMBER
}

func new_bug(id: String, type: BUG_TYPE) -> Node2D:
	# now pick one of the 4 random quadrants around the center of the player's base (for now just the origin)
	# todo - get number of plants which helps us determine what is "safely away" from the base
	var safe_base = 200.0
	var quadrant = rng.randi_range(0, 3)
	var destination: Vector2
	match quadrant:
		0:
			destination = Vector2(rng.randf_range(safe_base, safe_base * 2), rng.randf_range(safe_base, safe_base * 2))
		1:
			destination = Vector2(rng.randf_range(-safe_base, -(safe_base * 2)), rng.randf_range(safe_base, safe_base * 2))
		2:
			destination = Vector2(rng.randf_range(-safe_base, -(safe_base * 2)), rng.randf_range(-safe_base, -(safe_base * 2)))
		3: 
			destination = Vector2(rng.randf_range(safe_base, safe_base * 2), rng.randf_range(-safe_base, -(safe_base * 2)))
	
	if (type == BUG_TYPE.BOMBER):
		var inst = bomber_scene.instantiate()
		inst.position = destination
		var bomber_node: BomberBug = inst
		bomber_node.initialize(id)
		return bomber_node
	else:
		var inst = ant_scene.instantiate()
		inst.position = destination
		var ant_node: Ant = inst
		ant_node.initialize(id)
		return ant_node

func desired_enemies() -> int:
	return current_round * wave_amount

func add_plant(plant: PackedScene, position: Vector2):
	var base_plant = tomato_plant_scene.instantiate()
	base_plant.position = position
	var num_plants = str(num_current_plants)
	self.active_plants[str(num_plants)] = base_plant
	var plant_script: Plant = base_plant
	plant_script.initialize()
	add_child(base_plant)
	num_current_plants += 1

func _ready():
	add_plant(tomato_plant_scene, Vector2(0, 0))
	add_plant(tomato_plant_scene, Vector2(150, 0))

func _process(delta: float) -> void:
	if active_bugs.size() < desired_enemies():
		var bug_id = str(self.num_current_bugs)
		var rand_bug = randi_range(-1, 1)
		var type = BUG_TYPE.BOMBER
		if (rand_bug == -1):
			type = BUG_TYPE.ANT
		
		var ant = new_bug(bug_id, type)
		add_child(ant)
		active_bugs.push_back(ant)
		self.num_current_bugs += 1
		# handle bug targetting
	for i in range(len(self.active_bugs)):
		# hack for when range is called and dead bug is tried
		if (i >= len(self.active_bugs)):
			continue
		
		var current_bug = self.active_bugs[i]
		var bug_script: Bug = current_bug
		
		if (bug_script.total_hp <= 0):
			#self.active_bugs.erase(id)
			self.active_bugs.remove_at(i)
			bug_script.die()
			num_current_bugs -= 1
			continue
		
		if (bug_script.get_target() != null):
			# progress them toward their target
			bug_script.move_to_target()
			continue
		
		var distance = INF
		for plant_id in self.active_plants:
			var plant_script: Plant = self.active_plants[plant_id]
			# check if the plant is still alive
			if (plant_script.total_hp <= 0):
				self.active_plants.erase(plant_id)
				plant_script.die()
				num_current_plants -= 1
				continue
			
			var plant_distance = current_bug.position.distance_to(self.active_plants[plant_id].position)
			if (plant_distance < distance):
				distance = plant_distance
				bug_script.set_target(self.active_plants[plant_id])
	
	# handle plant targetting
	for plant_id in self.active_plants:
		var plant_script: Plant = self.active_plants[plant_id]
		var distance = INF
		
		for i in range(len(self.active_bugs)):
			var bug_script: Bug = self.active_bugs[i]
			var current_distance = self.active_plants[plant_id].position.distance_to(self.active_bugs[i].position)
			if (current_distance < distance):
				distance = current_distance
				if (distance <= plant_script.range):
					plant_script.set_target(self.active_bugs[i])
