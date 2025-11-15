extends Node2D

class_name Manager

const ant_scene: PackedScene = preload("res://Scenes/ant.tscn")
const bomber_scene: PackedScene = preload("res://Scenes/bomber-bug.tscn")
const tomato_plant_scene: PackedScene = preload("res://Scenes/tomato-plant.tscn")
const pea_plant_scene: PackedScene = preload("res://Scenes/pea-plant.tscn")

@export var col_height: float = 112
@export var row_width: float = 112
@export var num_cols: int = 20
@export var num_rows: int = 20

var game_grid: Array[Array] = []
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

enum PLANT_TYPE {
	TOMATO,
	PEA
}

# helper to get the nearest grid col & row based off a set of world coordinates 
func get_grid_from_world_vec(world: Vector2) -> Vector2:
	# todo - check if completely out of bounds
	var col = roundi(world.x/self.col_height)
	var row = roundi(world.y/self.row_width)
	return Vector2(col, row)
	
# helper for determining if an object can be placed in the grid or not,
# returns empty array if cannot be placed
func can_place_in_grid(coords: Vector2, dimensions: Vector2) -> Array:
	var desired_indices = []
	
	var allowed: bool = true
	for i in range(dimensions.x):
		for j in range(dimensions.y):
			if (self.game_grid[coords.x + i][coords.y + j] == null):
				desired_indices.push_back(Vector2(coords.x+i, coords.y+j))
			else:
				allowed = false
				break
	if (!allowed):
		return []
	return desired_indices
	
func place_in_grid(id: String, coords: Vector2, dimensions: Vector2) -> bool:
	var desired_coords = self.can_place_in_grid(coords, dimensions)
	if (len(desired_coords) > 0):
		for coord in desired_coords:
			self.game_grid[coord.x][coord.y] = id
		return true
	return false

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

func add_plant(plant_type: PLANT_TYPE, col: int, row:int):
	var plant_node: Node2D
	var plant_script: Plant
	var plant_id = str(num_current_plants)
	
	if (plant_type == PLANT_TYPE.TOMATO):
		plant_node = tomato_plant_scene.instantiate()
	elif (plant_type == PLANT_TYPE.PEA):
		plant_node = pea_plant_scene.instantiate()
		
	plant_script = plant_node
	# is there anything in our grid at these coords?
	if (place_in_grid(plant_id, Vector2(col, row), plant_script.get_dimensions())):
		# get the position derived from the col & row
		plant_node.position = Vector2(col * self.col_height, row * self.row_width)
		self.active_plants[plant_id] = plant_node
		plant_script.initialize()
		add_child(plant_node)
		num_current_plants += 1

func _ready():
	# generate our game grid structure
	for i in range(self.num_cols):
		var column = []
		for j in range(self.num_rows):
			column.push_back(null)
		self.game_grid.push_back(column)
	
	add_plant(PLANT_TYPE.TOMATO, 4, 4)
	add_plant(PLANT_TYPE.PEA, 5, 5)

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
				# todo: clean up the grid coords for this plant
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
