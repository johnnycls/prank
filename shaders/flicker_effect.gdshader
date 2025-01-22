shader_type canvas_item;

// Uniforms for controlling the flicker effect
uniform bool flicker_active = false; // Toggle flicker effect
uniform float flicker_speed : hint_range(0.1, 10.0) = 10.0; // Speed of flicker
uniform vec4 flicker_color = vec4(1.0, 1.0, 1.0, 1.0); // Color to flicker

void fragment() {
	vec4 base_color = texture(TEXTURE, UV); // Get the original texture color
	
	if (flicker_active) {
		float flicker_value = sin(TIME * flicker_speed) * 0.5 + 0.5; // Oscillates between 0 and 1
		base_color = mix(base_color, flicker_color, flicker_value); // Mix with flicker color
	}
	
	COLOR = base_color; // Output the final color
}