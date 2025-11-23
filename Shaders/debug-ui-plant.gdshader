shader_type canvas_item;

instance uniform bool canAfford;

void fragment() {
	vec4 texColor = texture(TEXTURE, UV);
	if (canAfford == true) {
		COLOR = texColor;
	} else {
		COLOR = vec4(texColor.g, texColor.g, texColor.g, texColor.w);
	}
}
