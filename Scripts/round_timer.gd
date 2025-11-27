extends AnimatedSprite2D

func _ready() -> void:
	print(int(Globals.game_speed))

func _process(delta: float) -> void:
	self.frame = int(Globals.game_speed) - 1
	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			Globals.set_game_speed(Globals.game_speed + 1)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			Globals.set_game_speed(Globals.game_speed - 1)
		
