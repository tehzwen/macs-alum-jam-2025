extends Camera2D

const PLANT_PLACE_SFX = preload("res://Sound/SFX/Gameplay/plant-add-remove.wav")

@export var ZOOM_FACTOR: float = 0.1
@export var MAX_ZOOM: float = 3.0

var ui_audio: AudioStreamPlayer
var manager: Manager

func _ready() -> void:
	manager = self.get_node("../Spawner")
	ui_audio = self.get_node("../UISound")

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT):
			# get the parent, then call our manager script func to place a plant
			var grid_coords = manager.get_grid_from_world_vec(get_global_mouse_position())
			manager.add_plant(manager.PLANT_TYPE.TOMATO, grid_coords.x, grid_coords.y)
			ui_audio.stream = PLANT_PLACE_SFX
			ui_audio.play()
		#elif (event.button_index == MOUSE_BUTTON_RIGHT):
			#print("right click")
		elif (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			self.zoom -= Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
		elif (event.button_index == MOUSE_BUTTON_WHEEL_UP):
			if (self.zoom.x < MAX_ZOOM and self.zoom.y < MAX_ZOOM):
				self.zoom += Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
	
	if (event is InputEventMouseMotion):
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			var movement: Vector2 = event.relative
			self.position += -movement
