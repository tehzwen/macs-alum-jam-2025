extends AnimatedSprite2D

var is_active: bool

func _ready() -> void:
	is_active = false

func _process(_delta: float) -> void:
	if self.is_active:
		self.frame = 1
	else:
		self.frame = 0
