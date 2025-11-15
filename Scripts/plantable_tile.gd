extends Node2D

class_name PlantableTile

var sprite: Sprite2D

enum TILE_SPOT {
	TOP_LEFT = 0,
	TOP_MIDDLE = 1,
	TOP_RIGHT = 2,
	MIDDLE_LEFT = 3,
	MIDDLE = 4,
	MIDDLE_RIGHT = 5,
	BOTTOM_LEFT = 6,
	BOTTOM_MIDDLE = 7,
	BOTTOM_RIGHT = 8
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = get_node("FarmTileSet")

func set_tile_spot(spot: TILE_SPOT):
	sprite.frame = spot
