shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

uniform vec4 light_color : source_color = vec4(1.0, 0.95, 0.8, 1.0);
uniform float strength : hint_range(0.0, 2.0) = 1.0;
uniform float softness : hint_range(0.0, 1.0) = 0.2;

void fragment() {
    vec4 screen_col = texture(SCREEN_TEXTURE, SCREEN_UV);

    // Use this object's alpha as mask
    float mask = texture(TEXTURE, UV).a;

    // soften edges
    mask = smoothstep(0.0, softness, mask);

    // apply color lighting
    vec3 lit = screen_col.rgb + (light_color.rgb * strength);

    // blend only where mask exists
    COLOR.rgb = mix(screen_col.rgb, lit, mask * light_color.a);
    COLOR.a = mask;
}
