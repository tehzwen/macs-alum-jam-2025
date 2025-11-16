extends Control

var manager: Manager
var numPlantsLabel: RichTextLabel
var numBugsLabel: RichTextLabel
var remainingLabel: RichTextLabel
var roundLabel: RichTextLabel
var killsLabel: RichTextLabel
var tomato: Sprite2D
var pea: Sprite2D
var fly_trap: Sprite2D
var vine: Sprite2D

func _ready() -> void:
	manager = get_node('../Spawner')
	numPlantsLabel = get_node('CanvasLayer/NumPlants')
	numBugsLabel = get_node("CanvasLayer/NumBugs")
	remainingLabel = get_node("CanvasLayer/Remaining")
	roundLabel = get_node("CanvasLayer/Round")
	killsLabel = get_node("CanvasLayer/Kills")
	tomato = get_node("CanvasLayer/Panel/Tomato")
	pea = get_node("CanvasLayer/Panel/Pea")
	fly_trap = get_node("CanvasLayer/Panel/FlyTrap")
	vine = get_node("CanvasLayer/Panel/Vine")

func reset_selected_uniforms():
	tomato.set_instance_shader_parameter("isSelected", false)
	pea.set_instance_shader_parameter("isSelected", false)
	fly_trap.set_instance_shader_parameter("isSelected", false)
	vine.set_instance_shader_parameter("isSelected", false)

func _process(delta: float) -> void:
	numPlantsLabel.text = "Num Plants: %d" % manager.get_num_plants()
	numBugsLabel.text = "Num Bugs: %d" % manager.get_num_bugs()
	remainingLabel.text = "Remaining: %d" % manager.get_remaining()
	roundLabel.text = "Round: %d" % manager.get_round()
	killsLabel.text = "Kills: %d" % manager.get_kills()
	
	# set uniforms
	var current_plant_type = manager.get_selected_type()
	if (current_plant_type == Manager.PLANT_TYPE.TOMATO):
		self.reset_selected_uniforms()
		tomato.set_instance_shader_parameter("isSelected", true)
	elif(current_plant_type == Manager.PLANT_TYPE.PEA):
		self.reset_selected_uniforms()
		pea.set_instance_shader_parameter("isSelected", true)
	elif(current_plant_type == Manager.PLANT_TYPE.FLY_TRAP):
		self.reset_selected_uniforms()
		fly_trap.set_instance_shader_parameter("isSelected", true)
	elif(current_plant_type == Manager.PLANT_TYPE.VINE):
		self.reset_selected_uniforms()
		vine.set_instance_shader_parameter("isSelected", true)
