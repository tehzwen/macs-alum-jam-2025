extends Camera2D

@export var ZOOM_FACTOR: float = 0.1
@export var MAX_ZOOM: float = 3.0

func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT):
			print("left click")
		elif (event.button_index == MOUSE_BUTTON_RIGHT):
			print("right click")
		elif (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			self.zoom -= Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
			print(self.zoom)
		elif (event.button_index == MOUSE_BUTTON_WHEEL_UP):
			if (self.zoom.x < MAX_ZOOM and self.zoom.y < MAX_ZOOM):
				self.zoom += Vector2(ZOOM_FACTOR, ZOOM_FACTOR)
				print(self.zoom)
		elif (event.button_index == MOUSE_BUTTON_MIDDLE):
			print("mouse middle clicked")
	
	if (event is InputEventMouseMotion):
		if event.button_mask == MOUSE_BUTTON_MASK_MIDDLE:
			var movement: Vector2 = event.relative
			self.position += -movement
