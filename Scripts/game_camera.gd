extends Camera2D

const PLANT_PLACE_SFX = preload("res://Sound/SFX/Gameplay/plant-add-remove.wav")

@export var ZOOM_FACTOR: float = 0.1
@export var MAX_ZOOM_IN: float = 3.0
@export var MAX_ZOOM_OUT: float = 1.2

var ui_audio: AudioStreamPlayer
var manager: Manager

func _ready() -> void:
	manager = self.get_node("../Spawner")
	ui_audio = self.get_node("../UISound")
	position = manager.get_grid_center_world_coords()
	var grid_rect = manager.get_grid_world_rect()
	self.limit_bottom = grid_rect.size.y - (manager.row_width/2)
	self.limit_right = grid_rect.size.x - (manager.col_height/2)
	self.limit_top = -(manager.row_width/2)
	self.limit_left = -(manager.col_height/2)

func _input(event: InputEvent) -> void:
	if (event is InputEventKey):
		if (event.keycode == KEY_1):
			self.manager.set_selected_type(Manager.PLANT_TYPE.TOMATO)
		elif (event.keycode == KEY_2):
			self.manager.set_selected_type(Manager.PLANT_TYPE.PEA)
		elif (event.keycode == KEY_3):
			self.manager.set_selected_type(Manager.PLANT_TYPE.FLY_TRAP)
		elif (event.keycode == KEY_4):
			self.manager.set_selected_type(Manager.PLANT_TYPE.VINE)
			
		if event.keycode == KEY_EQUAL and event.pressed:
			Globals.set_game_speed(Globals.game_speed + 1)
		if event.keycode == KEY_MINUS and event.pressed:
			Globals.set_game_speed(Globals.game_speed - 1)
			
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
			# get the parent, then call our manager script func to place a plant
			var grid_coords = manager.get_grid_from_world_vec(get_global_mouse_position())
			manager.add_plant(self.manager.get_selected_type(), grid_coords.x, grid_coords.y)
			ui_audio.stream = PLANT_PLACE_SFX
			ui_audio.play()
		#elif (event.button_index == MOUSE_BUTTON_RIGHT):
			#print("right click")
		elif (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			if (self.zoom.x > MAX_ZOOM_OUT and self.zoom.y > MAX_ZOOM_OUT):
				self.zoom -= Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
		elif (event.button_index == MOUSE_BUTTON_WHEEL_UP):
			if (self.zoom.x < MAX_ZOOM_IN and self.zoom.y < MAX_ZOOM_IN):
				self.zoom += Vector2(ZOOM_FACTOR, ZOOM_FACTOR)

	if (event is InputEventMouseMotion):
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			var movement: Vector2 = event.relative
			self.position += -movement
