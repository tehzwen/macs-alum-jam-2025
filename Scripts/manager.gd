extends Node2D

class_name Manager

const ant_scene: PackedScene = preload("res://Scenes/ant.tscn")
const bomber_scene: PackedScene = preload("res://Scenes/bomber-bug.tscn")
const tomato_plant_scene: PackedScene = preload("res://Scenes/tomato-plant.tscn")
const pea_plant_scene: PackedScene = preload("res://Scenes/pea-plant.tscn")
const plantable_tile_scene: PackedScene = preload("res://Scenes/plantable-tile.tscn")

@export var col_height: float = 112
@export var row_width: float = 112
@export var num_cols: int = 10
@export var num_rows: int = 10

var game_grid: Array[Array] = []
var active_bugs = []
var active_plants = []
var num_current_bugs = 0
var num_current_plants = 0
var current_round: int = 1
var wave_amount: int = 20
var kills: int = 0
var rng = RandomNumberGenerator.new()
var wave_manager = WaveManager.new()

enum BUG_TYPE {
	ANT,
	BOMBER
}

enum PLANT_TYPE {
	TOMATO,
	PEA
}

func get_kills() -> int:
	return self.kills
	
func get_num_plants() -> int:
	return self.active_plants.size()
	
func get_num_bugs() -> int:
	return len(self.active_bugs)

func get_round() -> int:
	return self.wave_manager.current_wave_num

func get_remaining() -> int:
	return self.wave_manager.get_remaining() + self.wave_manager.get_active_enemy_count()

# helper to get the nearest grid col & row based off a set of world coordinates 
func get_grid_from_world_vec(world: Vector2) -> Vector2:
	# todo - check if completely out of bounds
	var col = roundi(world.x/self.col_height)
	var row = roundi(world.y/self.row_width)
	return Vector2(col, row)
	
func clear_grid_positions(coords: Vector2, dimensions: Vector2):
	for i in range(dimensions.x):
		for j in range(dimensions.y):
			self.game_grid[coords.x + i][coords.y + j] = null
	
# helper for determining if an object can be placed in the grid or not,
# returns empty array if cannot be placed
func can_place_in_grid(coords: Vector2, dimensions: Vector2) -> Array:
	var desired_indices = []
	
	print(coords)
	
	var allowed: bool = true
	for i in range(dimensions.x):
		for j in range(dimensions.y):
			if ((coords.x + i > self.num_cols - 2 or coords.y + j > self.num_rows - 2) or (coords.x + i < 1 or coords.y + j < 1)):
				allowed = false
				break
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
		self.active_plants.push_back(plant_node)
		plant_script.initialize()
		plant_script.grid_position = Vector2(col, row)
		add_child(plant_node)
		num_current_plants += 1

func _ready():
	self.wave_manager.initialize()
	
	# generate our game grid structure
	for i in range(self.num_cols):
		var column = []
		for j in range(self.num_rows):
			column.push_back(null)
			# spawn in the tile, todo - handle cases on edges where we want to spawn the edge pieces
			var tile_node = plantable_tile_scene.instantiate()
			tile_node.position = Vector2(self.col_height * i, self.row_width * j)
			var tile_node_script: PlantableTile = tile_node
			add_child(tile_node)
			
			# top left
			if (i == 0 and j == 0):
				tile_node_script.set_tile_spot(PlantableTile.TILE_SPOT.TOP_LEFT)
			# bottom left
			elif (i == 0 and j == self.num_rows - 1):
				tile_node_script.set_tile_spot(PlantableTile.TILE_SPOT.BOTTOM_LEFT)
			# top right
			elif (i == self.num_cols - 1 and j == 0):
				tile_node_script.set_tile_spot(PlantableTile.TILE_SPOT.TOP_RIGHT)
			# bottom right
			elif (i == self.num_cols - 1 and j == self.num_rows - 1):
				tile_node_script.set_tile_spot(PlantableTile.TILE_SPOT.BOTTOM_RIGHT)
			# left row
			elif (i == 0):
				tile_node_script.set_tile_spot(PlantableTile.TILE_SPOT.MIDDLE_LEFT)
			# top row
			elif (j == 0):
				tile_node_script.set_tile_spot(PlantableTile.TILE_SPOT.TOP_MIDDLE)
			# right row
			elif (i == self.num_cols - 1):
				tile_node_script.set_tile_spot(PlantableTile.TILE_SPOT.MIDDLE_RIGHT)
			# bottom row
			elif (j == self.num_rows - 1):
				tile_node_script.set_tile_spot(PlantableTile.TILE_SPOT.BOTTOM_MIDDLE)
				
		self.game_grid.push_back(column)
	
	add_plant(PLANT_TYPE.TOMATO, 4, 4)
	add_plant(PLANT_TYPE.PEA, 5, 5)

func _process(delta: float) -> void:
	if active_bugs.size() < self.wave_manager.get_active_enemy_count() and self.wave_manager.get_remaining() > 0:
		var bug_id = str(self.num_current_bugs)
		var rand_bug = randi_range(-1, 1)
		var type = BUG_TYPE.BOMBER
		if (rand_bug == -1):
			type = BUG_TYPE.ANT
		
		var ant = new_bug(bug_id, type)
		add_child(ant)
		active_bugs.push_back(ant)
		self.num_current_bugs += 1
	elif active_bugs.size() == 0 and self.wave_manager.get_remaining() < 0 and not self.wave_manager.waiting:
		# todo - run a timer here then spawn the next wave
		self.wave_manager.waiting = true
		await get_tree().create_timer(3.0).timeout
		self.wave_manager.next_wave()
	
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
			self.kills += 1
			self.wave_manager.increment_killed()
			num_current_bugs -= 1
			continue
		
		if (bug_script.get_target() != null):
			# progress them toward their target
			bug_script.move_to_target()
			continue
		
		var distance = INF
		for j in range(len(self.active_plants)):
			# hack for when range is called and dead plant is tried
			if (j >= len(self.active_plants)):
				continue
			var plant_script: Plant = self.active_plants[j]
			# check if the plant is still alive
			if (plant_script.total_hp <= 0):
				self.active_plants.remove_at(j)
				# todo: clean up the grid coords for this plant
				clear_grid_positions(plant_script.grid_position, plant_script.get_dimensions())
				plant_script.die()
				num_current_plants -= 1
				continue
			
			var plant_distance = current_bug.position.distance_to(self.active_plants[j].position)
			if (plant_distance < distance):
				distance = plant_distance
				bug_script.set_target(self.active_plants[j])
	
	# handle plant targetting
	for i in range(len(self.active_plants)):
		var plant_script: Plant = self.active_plants[i]
		var distance = INF
		
		for j in range(len(self.active_bugs)):
			var bug_script: Bug = self.active_bugs[j]
			var current_distance = self.active_plants[i].position.distance_to(self.active_bugs[j].position)
			if (current_distance < distance):
				distance = current_distance
				if (distance <= plant_script.range):
					plant_script.set_target(self.active_bugs[j])
