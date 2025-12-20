shader_type spatial;
render_mode unshaded, depth_prepass_alpha;


uniform vec4 color: source_color = vec4(1.);

void fragment() {
	ALBEDO = color.rgb;
	ALPHA *= color.a;
}