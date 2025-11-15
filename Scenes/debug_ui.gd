extends Control

var manager: Manager
var numPlantsLabel: RichTextLabel
var numBugsLabel: RichTextLabel
var remainingLabel: RichTextLabel
var roundLabel: RichTextLabel
var killsLabel: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	manager = get_node('../Spawner')
	numPlantsLabel = get_node('CanvasLayer/NumPlants')
	numBugsLabel = get_node("CanvasLayer/NumBugs")
	remainingLabel = get_node("CanvasLayer/Remaining")
	roundLabel = get_node("CanvasLayer/Round")
	killsLabel = get_node("CanvasLayer/Kills")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	numPlantsLabel.text = "Num Plants: %d" % manager.get_num_plants()
	numBugsLabel.text = "Num Bugs: %d" % manager.get_num_bugs()
	remainingLabel.text = "Remaining: %d" % manager.get_remaining()
	roundLabel.text = "Round: %d" % manager.get_round()
	killsLabel.text = "Kills: %d" % manager.get_kills()
