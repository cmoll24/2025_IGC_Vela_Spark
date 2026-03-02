shader_type canvas_item;

// Width of the rectangle
uniform float width = 0.5;

// Rotation of the rectangle
uniform float rotation : hint_range(-90.0, 90.0) = 0.0;

// Center point of the polygon
uniform float position_x = 0.5;

void fragment() {
	// Pull in the texture.
	COLOR = texture(TEXTURE, UV);
	
	float width_x = width * cos(radians(rotation));
	float width_y = width * sin(radians(rotation));
	float slope = tan(radians(rotation));
		
	if (UV.x - position_x - width_x > (slope * (UV.y + width_y))) {
		COLOR.a = 0.0;
	}
	
	if (UV.x - position_x < slope * UV.y) {
		COLOR.a = 0.0;
	}
}