shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

// Width of the rectangle
uniform float width = 0.5;

// Rotation of the rectangle
uniform float rotation : hint_range(-90.0, 90.0) = 0.0;

// Center point of the polygon
uniform float position_x = 0.5;

void fragment() {
	// Pull in the texture.
	//COLOR = texture(TEXTURE, UV);
	vec4 tex_color = texture(SCREEN_TEXTURE, UV);

	COLOR = tex_color;
    //COLOR.rgb = texture(TEXTURE, UV);//mix(vec3(dot(tex_color.rgb, vec3(0.299, 0.587, 0.114))), tex_color.rgb, saturation);
	
	float width_x = width * cos(radians(rotation));
	float width_y = width * sin(radians(rotation));
	float slope = tan(radians(rotation));
		
	if (UV.x - position_x - width_x < (slope * (UV.y + width_y)) && (UV.x - position_x > slope * UV.y)) {
		COLOR.b = 0.0;
	} else {
		COLOR.a = 0.0;
	}
}