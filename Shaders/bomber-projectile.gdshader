shader_type canvas_item;

uniform vec3 base_colour;
instance uniform float attack_timer;

void fragment() {
	COLOR = vec4(base_colour.r, base_colour.g, sin(base_colour.b * TIME * 150.0), attack_timer);
}