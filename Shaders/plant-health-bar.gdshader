shader_type canvas_item;

instance uniform float health_percentage;

void vertex() {
	float normalized_health = health_percentage;
	if (normalized_health > 1.0) {
		normalized_health = 1.0;
	}
	
	VERTEX.x = VERTEX.x * normalized_health;
	float difference = 1.0 - normalized_health;
	VERTEX.x = VERTEX.x - (difference/2.0);
}

void fragment() {
	COLOR = vec4(1.0, 0.0, 0.0, 0.4);
}
