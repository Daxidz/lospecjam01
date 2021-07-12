shader_type canvas_item;

uniform vec2 direction = vec2(0.0,-1.0);
uniform float speed_scale = 0.1;
uniform float speed_factor = 1.0;

void fragment(){

     vec2 move = direction * TIME * speed_scale * speed_factor;

     COLOR = texture(TEXTURE, UV + move);   
}