extends Control

var manager: Manager

func _ready() -> void:
	manager = get_node('../Spawner')

func reset_selected_uniforms():
	$CanvasLayer/AnimatedPanel/Tomato.is_active = false
	$CanvasLayer/AnimatedPanel/Pea.is_active = false
	$CanvasLayer/AnimatedPanel/FlyTrap.is_active = false
	$CanvasLayer/AnimatedPanel/Vine.is_active = false

func _process(_delta: float) -> void:
	var current_plant_type = manager.get_selected_type()
	if (current_plant_type == Manager.PLANT_TYPE.TOMATO):
		self.reset_selected_uniforms()
		$CanvasLayer/AnimatedPanel/Tomato.is_active = true
	elif(current_plant_type == Manager.PLANT_TYPE.PEA):
		self.reset_selected_uniforms()
		$CanvasLayer/AnimatedPanel/Pea.is_active = true
	elif(current_plant_type == Manager.PLANT_TYPE.FLY_TRAP):
		self.reset_selected_uniforms()
		$CanvasLayer/AnimatedPanel/FlyTrap.is_active = true
	elif(current_plant_type == Manager.PLANT_TYPE.VINE):
		self.reset_selected_uniforms()
		$CanvasLayer/AnimatedPanel/Vine.is_active = true
