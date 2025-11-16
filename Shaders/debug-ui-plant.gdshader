shader_type canvas_item;

instance uniform bool isSelected;

void fragment() {
	vec4 texColor = texture(TEXTURE, UV);
	if (isSelected == true) {
		COLOR = vec4((cos(TIME * 4.0) + 1.5), 0.0, 0.0, texColor.w);
	} else {
		COLOR = vec4(1.0, 1.0, 1.0, texColor.w);
	}
}
