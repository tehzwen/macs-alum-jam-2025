extends Node2D

class_name AntHill

var spawn_timer = 0
var spawn_cooldown = 3.0

signal on_ant_hill_spawn()
signal on_ant_hill_die() # TODO - handle when the anthill dies

func _on_sprite_animation_finished() -> void:
	# if we are playing the spawning animation, swap to default
	if $Sprite.animation == "spawn":
		$Sprite.play("default")

func _ready() -> void:
	$Sprite.play("spawn")

func _process(delta: float) -> void:
	spawn_timer += delta
	if spawn_timer >= spawn_cooldown:
		on_ant_hill_spawn.emit()
		spawn_timer = 0.0
