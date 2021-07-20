shader_type canvas_item;

uniform vec4 target_col: hint_color;
uniform vec4 replace_col: hint_color;
uniform bool enabled;

void fragment(){
	if (!enabled) return;
	vec4 cur_color = texture(TEXTURE, UV);
	vec4 bg_col = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
	
	vec4 d4 = abs(bg_col - target_col);
    float d = max(max(d4.r, d4.g), d4.b);
	
    float dc = length(UV - 0.5);
    float c = dc < 0.3 ? 1.0 : 0.0;
	
//	if ((d < 0.01) && (cur_color.a > 0.0) && c != 0.0) {
	if ((d < 0.01) && (cur_color.a > 0.0)) {
		COLOR = replace_col;
	} else {
		COLOR.a = 0.0
	}
}