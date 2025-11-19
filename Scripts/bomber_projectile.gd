extends Node2D

class_name BomberProjectile

@export var speed: float = 3.0
@export var damage: float = 5
@export var max_distance: float = 250

var projectile_explosion_sound: AudioStreamPlayer2D
var direction: Vector2
var distance_travelled: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	projectile_explosion_sound = get_node("ExplosionSound")

func _process(delta: float) -> void:
	self.position += self.direction * self.speed
	self.distance_travelled += self.speed
	
	if (self.distance_travelled > self.max_distance):
		projectile_explosion_sound.play()

func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var plant_script: Plant = area.get_parent()
	plant_script.take_damage(self.damage)
	self.hide()
	self.speed = 0
	projectile_explosion_sound.play()

func _on_explosion_sound_finished() -> void:
	queue_free()
