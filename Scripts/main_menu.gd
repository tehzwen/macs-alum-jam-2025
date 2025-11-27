extends Control

#@onready var play_button: Button = $PlayButton
#@onready var options_button: Button = $OptionsButton
#@onready var quit_button: Button = $QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Connected via the editor.  This would be an in-code solution for future reference
	#play_button.pressed.connect(_on_play_pressed)
	#options_button.pressed.connect(_on_options_pressed)
	#quit_button.pressed.connect(_on_quit_pressed)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main-scene.tscn")


func _on_options_button_pressed() -> void:
	
	#get path to options container
	#hide current menu container
	#turn on visibility of the options container
	pass


func _on_quit_button_pressed() -> void:
	get_tree().quit()
