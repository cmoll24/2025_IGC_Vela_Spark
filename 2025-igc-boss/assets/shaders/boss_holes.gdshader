shader_type canvas_item;

uniform int hole_count : hint_range(0, 64) = 0;
uniform float seed = 2.0;

// Size of one frame in pixels (set from script)
uniform vec2 sprite_size = vec2(64.0, 64.0);
// Offset of the sprite's center in local space (0,0 if "Centered" is on)
uniform vec2 center_offset = vec2(0.0, 0.0);

uniform float min_radius = 4.0;
uniform float max_radius = 12.0;
// How much of the sprite area holes can land in (1.0 = whole rect)
uniform float spread : hint_range(0.1, 1.0) = 0.7;

// Burnt / damaged edge around each hole
uniform vec4 rim_color : source_color = vec4(0.1, 0.0, 0.0, 1.0);
uniform float rim_width = 2.0;

varying vec2 local_pos;

float hash11(float n) {
	return fract(sin(n * 127.1) * 43758.5453);
}

vec3 hash13(float n) {
	return vec3(
		hash11(n + 1.0),
		hash11(n + 2.0 + seed * 7.31),
		hash11(n + 3.0 + seed * 3.17)
	);
}

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	float min_d = 1e6;

	for (int i = 0; i < 64; i++) {
		if (i >= hole_count) break;

		vec3 h = hash13(float(i) * 13.37 + seed * 91.7);
		vec2 center = center_offset + (h.xy - 0.5) * sprite_size * spread;
		float radius = mix(min_radius, max_radius, h.z);

		// Signed distance to this hole's edge (negative = inside hole)
		min_d = min(min_d, distance(local_pos, center) - radius);
	}

	// Cut out the holes (with ~1px antialiasing)
	COLOR.a *= smoothstep(-0.5, 0.5, min_d);

	// Darkened rim so the holes look like chunks were torn out
	float rim = 1.0 - smoothstep(0.0, rim_width, min_d);
	COLOR.rgb = mix(COLOR.rgb, rim_color.rgb, rim * rim_color.a);
}