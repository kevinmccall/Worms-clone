shader_type canvas_item;
render_mode unshaded;

uniform sampler2D mask;

void fragment() {
	vec4 mask_colors = texture(mask, UV);
	vec4 original_colors = texture(TEXTURE, UV);
	float alpha = mask_colors.a * original_colors.a;
//	COLOR = vec4(original_colors.rgb, alpha);
	COLOR = vec4(original_colors.rgb, alpha);
	
}