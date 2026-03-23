shader_type spatial;
render_mode unshaded, depth_prepass_alpha;


uniform vec4 color: source_color = vec4(1.);

varying vec4 vertex_color;

void vertex() {
	vertex_color = COLOR;
}

void fragment() {
	ALBEDO = color.rgb;
	ALPHA *= color.a * vertex_color.a;
}