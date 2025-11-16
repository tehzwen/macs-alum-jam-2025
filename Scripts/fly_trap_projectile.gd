extends Node2D

class_name FlyTrapProjectile

@export var damage: float = 50

var target: Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")
