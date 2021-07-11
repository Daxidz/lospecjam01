shader_type canvas_item;

uniform vec4 color : hint_color;

void fragment() {
	vec4 cur_color = texture(TEXTURE, UV);
	if (cur_color == vec4(0,0,0,1)) {
		COLOR = color;
	} else {
		COLOR = cur_color;
	}

} 