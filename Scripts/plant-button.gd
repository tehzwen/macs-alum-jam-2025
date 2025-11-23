extends AnimatedSprite2D

@export var plant_type: Manager.PLANT_TYPE
var is_active: bool

func _ready() -> void:
	is_active = false
	
func set_can_afford(value: bool):
	self.set_instance_shader_parameter("canAfford", value)
	
func _process(_delta: float) -> void:
	set_can_afford(Globals.cash >= Globals.get_plant_cost(self.plant_type))
	if self.is_active:
		self.play()
	else:
		self.stop()
