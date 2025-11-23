extends Control

var manager: Manager
var num_plants_label: RichTextLabel
var num_bugs_label: RichTextLabel
var remaining_label: RichTextLabel
var round_label: RichTextLabel
var kills_label: RichTextLabel
var game_speed_label: RichTextLabel

func _ready() -> void:
	manager = get_node('../Spawner')
	num_plants_label = get_node('CanvasLayer/NumPlants')
	num_bugs_label = get_node("CanvasLayer/NumBugs")
	remaining_label = get_node("CanvasLayer/Remaining")
	round_label = get_node("CanvasLayer/Round")
	kills_label = get_node("CanvasLayer/Kills")
	game_speed_label = get_node("CanvasLayer/GameSpeed")

func reset_selected_uniforms():
	$CanvasLayer/AnimatedPanel/Tomato.is_active = false
	$CanvasLayer/AnimatedPanel/Pea.is_active = false
	$CanvasLayer/AnimatedPanel/FlyTrap.is_active = false
	$CanvasLayer/AnimatedPanel/Vine.is_active = false

func _process(_delta: float) -> void:
	num_plants_label.text = "Num Plants: %d" % manager.get_num_plants()
	num_bugs_label.text = "Num Bugs: %d" % manager.get_num_bugs()
	remaining_label.text = "Remaining spawns: %d" % manager.get_remaining()
	round_label.text = "Round: %d" % manager.get_round()
	kills_label.text = "Kills: %d" % manager.get_kills()
	game_speed_label.text = "Game speed: %d" % Globals.game_speed
	
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
