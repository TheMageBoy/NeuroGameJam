shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(1.0, 16.0, 1.0) = 1.0;

void fragment() {
	// Called for every pixel the material is visible on.
	float x = FRAGCOORD.x - mod(FRAGCOORD.x,pixel_size);
	float y = FRAGCOORD.y - mod(FRAGCOORD.y,pixel_size);
	float shift = floor(pixel_size/2.0);
	COLOR = texture(screen_texture,vec2(x+shift,y+shift) * SCREEN_PIXEL_SIZE);
}
