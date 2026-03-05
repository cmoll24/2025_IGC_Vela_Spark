shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear, repeat_disable;

uniform vec4 light_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform float strength : hint_range(0.0, 2.0) = 1.0;

uniform float width_x = 0.5;
uniform float slope = 0.0;
//uniform float rotation : hint_range(-90.0, 90.0) = 0.0;
uniform float position_x : hint_range(0.0, 1.0) = 0.5;



void fragment() {
	// Clipping check
    if ((UV.x - position_x - width_x) > (slope * UV.y)) {
        //COLOR.a = 0.0;
		discard;
	}
    if ((UV.x - position_x) < (slope * UV.y)) {
        //COLOR.a = 0.0;
        discard;
	 }

    // Use this object's alpha as mask
    float mask = texture(TEXTURE, UV).a;
	
	if (mask < 0.001) {
        //COLOR.a = 0.0;
        discard;
    }
	
	vec4 screen_col = texture(SCREEN_TEXTURE, SCREEN_UV);
    // apply color lighting
    vec3 lit = screen_col.rgb + (light_color.rgb * strength);

    // blend
    COLOR.rgb = mix(screen_col.rgb, lit, mask * light_color.a);
}
