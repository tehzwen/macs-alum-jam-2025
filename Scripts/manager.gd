extends Node2D

class_name Manager

const ant_scene: PackedScene = preload("res://Scenes/ant.tscn")
const bomber_scene: PackedScene = preload("res://Scenes/bomber-bug.tscn")
const tomato_plant_scene: PackedScene = preload("res://Scenes/tomato-plant.tscn")
const pea_plant_scene: PackedScene = preload("res://Scenes/pea-plant.tscn")
const fly_trap_plant_scene: PackedScene = preload("res://Scenes/fly-trap-plant.tscn")
const vine_plant_scene: PackedScene = preload("res://Scenes/vine-plant.tscn")
const plantable_tile_scene: PackedScene = preload("res://Scenes/plantable-tile.tscn")
const ant_hill_scene: PackedScene = preload("res://Scenes/ant-hill.tscn")

var music_stream: AudioStreamPlayer
var manager: Manager

@export var col_height: float = 32
@export var row_width: float = 32
@export var num_cols: int = 50
@export var num_rows: int = 30

var game_grid: Array[Array] = []
var active_bugs = []
var active_plants = []
var active_anthills = []
var num_current_bugs = 0
var num_current_plants = 0
var num_ant_hills = 0
var current_round: int = 1
var wave_amount: int = 20
var kills: int = 0
var rng = RandomNumberGenerator.new()
var wave_manager = WaveManager.new()
var selected_type: PLANT_TYPE = PLANT_TYPE.TOMATO
var time_scale = 1.0
var spawn_points: Array[Vector2] = []
var ant_hill_chance = 25


enum BUG_TYPE {
	ANT,
	BOMBER
}

enum PLANT_TYPE {
	TOMATO,
	PEA,
	FLY_TRAP,
	VINE
}

func get_selected_type() -> PLANT_TYPE:
	return self.selected_type

func set_selected_type(type: PLANT_TYPE):
	self.selected_type = type

func get_kills() -> int:
	return self.kills
	
func get_num_plants() -> int:
	return self.active_plants.size()
	
func get_num_bugs() -> int:
	return len(self.active_bugs)

func get_round() -> int:
	return self.wave_manager.current_wave_num

func get_remaining() -> int:
	if self.wave_manager.get_remaining() > 0:
		return self.wave_manager.get_remaining()
	return 0
	
func get_grid_center_world_coords() -> Vector2:
	var row_center = (self.num_rows/2) * self.row_width
	var col_center = (self.num_cols/2) * self.col_height
	
	return Vector2(col_center, row_center)

func get_grid_world_rect() -> Rect2:
	return Rect2(0,0, self.num_cols * self.col_height, self.num_rows * self.row_width)

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
	var spawn_point = rng.randi_range(0, len(self.spawn_points) -1)
	var destination: Vector2 = self.spawn_points[spawn_point]
	
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
	
func spawn_ant_hill(coords: Vector2):
	var hill_node: Node2D = ant_hill_scene.instantiate()
	var hill_script: AntHill = hill_node
	
	if self.place_in_grid(str(len(self.active_anthills)), coords, Vector2(1,1)):
		hill_node.position = Vector2(coords.x * self.col_height, coords.y * self.row_width)
		self.spawn_points.push_back(hill_node.position)
		self.wave_manager.num_ant_hills += 1
		self.active_anthills.push_back(hill_node)
		num_ant_hills += 1
		add_child(hill_node)
		hill_script.on_ant_hill_spawn.connect(_on_ant_hill_spawn)

func add_plant(plant_type: PLANT_TYPE, col: int, row:int):
	var plant_node: Node2D
	var plant_script: Plant
	var plant_id = str(num_current_plants)
	
	if (plant_type == PLANT_TYPE.TOMATO):
		plant_node = tomato_plant_scene.instantiate()
	elif (plant_type == PLANT_TYPE.PEA):
		plant_node = pea_plant_scene.instantiate()
	elif (plant_type == PLANT_TYPE.FLY_TRAP):
		plant_node = fly_trap_plant_scene.instantiate()
	elif (plant_type == PLANT_TYPE.VINE):
		plant_node = vine_plant_scene.instantiate()
		
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

func _on_ant_hill_spawn():
	pass

func _ready():
	self.wave_manager.initialize()
	music_stream = self.get_node("../Music")
	
	generate_bug_spawn_points()
	
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
	
	add_plant(PLANT_TYPE.TOMATO, num_cols/2, num_rows/2)
	#add_plant(PLANT_TYPE.PEA, 5, 5)
	#add_plant(PLANT_TYPE.VINE, 4,4)

# helper to generate spawning points around the outside of the map
func generate_bug_spawn_points():
	var top_row = Vector2(0, rng.randi_range(0, num_rows-1))
	var bottom_row = Vector2(num_cols-1, rng.randi_range(0, num_rows-1))
	var left_col = Vector2(rng.randi_range(0, num_cols-1), 0)
	var right_col = Vector2(rng.randi_range(0, num_cols-1), num_rows-1)

	self.spawn_points.push_back(Vector2(top_row.x * self.col_height, top_row.y * self.row_width))
	self.spawn_points.push_back(Vector2(bottom_row.x * self.col_height, bottom_row.y * self.row_width))
	self.spawn_points.push_back(Vector2(left_col.x * self.col_height, left_col.y * self.row_width))
	self.spawn_points.push_back(Vector2(right_col.x * self.col_height, right_col.y * self.row_width))
	
	for ah in self.active_anthills:
		self.spawn_points.push_back(ah.position)
	
func random_free_grid_spot(dimensions: Vector2) -> Vector2:
	# try incremental pass from random starting spot
	var col = rng.randi_range(0, self.num_cols)
	var row = rng.randi_range(0, self.num_rows)
	
	for i in range(col, self.num_cols, 1):
		for j in range(row, self.num_rows, 1):
			print()
			if can_place_in_grid(Vector2(i,j), dimensions):
				return Vector2(i,j)
				
	for i in range(self.num_cols, col, -1):
		for j in range(self.num_rows, row, -1):
			print()
			if can_place_in_grid(Vector2(i,j), dimensions):
				return Vector2(i,j)
				
	return Vector2(-1, -1)
	
func next_wave():
	self.spawn_points = []
	# generate random chance for anthills, the higher the round the more likely
	var random_hill_spawn = rng.randi_range(0, 100)
	if random_hill_spawn <= self.ant_hill_chance:
		var spot = random_free_grid_spot(Vector2(1,1))
		if spot.x != -1:
			self.spawn_ant_hill(spot)
	self.ant_hill_chance += 2 # increase the likelihood of an ant hill for every round that happens
	self.generate_bug_spawn_points()
	self.wave_manager.next_wave()

func _process(_delta: float) -> void:
	if active_bugs.size() < self.wave_manager.get_active_enemy_count() and self.wave_manager.get_remaining() >= 0:
		var bug_id = str(self.num_current_bugs)
		var rand_bug = randi_range(-1, 1)
		var type = BUG_TYPE.BOMBER
		if (rand_bug == -1):
			type = BUG_TYPE.ANT
		
		var bug = new_bug(bug_id, type)
		add_child(bug)
		active_bugs.push_back(bug)
		self.num_current_bugs += 1
	elif active_bugs.size() == 0 and self.wave_manager.get_remaining() < 0 and not self.wave_manager.waiting:
		# todo - run a timer here then spawn the next wave
		self.wave_manager.waiting = true
		await get_tree().create_timer(3.0).timeout
		self.next_wave()
	# handle plant death
	for i in range(len(self.active_plants)):
		if (i >= len(self.active_plants)):
			continue
		var plant = self.active_plants[i]
		if (not is_instance_valid(plant)):
			continue
		
		var plant_script: Plant = self.active_plants[i]
		if (plant_script.total_hp <= 0):
			self.active_plants.remove_at(i)
			clear_grid_positions(plant_script.grid_position, plant_script.get_dimensions())
			plant_script.die()
			num_current_plants -= 1
			continue
			
	# handle bug death
	for i in range(len(self.active_bugs)):
		if (i >= len(self.active_bugs)):
			continue
		var bug = self.active_bugs[i]
		if (not is_instance_valid(bug)):
			continue
		
		var bug_script: Bug = self.active_bugs[i]
		if (bug_script.total_hp <= 0):
			self.active_bugs.remove_at(i)
			bug_script.die()
			self.wave_manager.increment_killed()
			num_current_bugs -= 1
			self.kills += 1
			continue

	var wave_number = wave_manager.get_wave_number()
	if wave_number > 1:
		var pitch_scale = 1.0 + (float(wave_manager.get_wave_number())/100.0)
		music_stream.pitch_scale = min(pitch_scale, 1.7) # 1.7 is ridiculously fast, cap it there
