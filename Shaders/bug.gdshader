shader_type canvas_item;

uniform vec3 base_color;
instance uniform float health_percentage; // health from 1.0 - 0.0

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	COLOR = vec4(mix(base_color, color.xyz, health_percentage), color.w);
}