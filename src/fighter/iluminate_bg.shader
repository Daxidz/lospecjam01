shader_type canvas_item;

uniform vec2 player_pos;
uniform float radius;

void fragment() {
	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	COLOR.rgb = vec3(1,1,1);
}