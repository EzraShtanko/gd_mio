shader_type canvas_item;


uniform float slope = 2.;
uniform float peak_a = 0.9;
uniform vec4 margins = vec4(0.25, 0.25, 0.25, 0.25);
uniform bool invert = false;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 color = COLOR;
	float alpha = COLOR.a;


	color.a = pow(clamp(1. - UV.x / margins.x, 0., 1.), slope);
	color.a = clamp(color.a + pow( clamp(1. - UV.y / margins.y, 0., 1.) , slope), 0., 1.);
	color.a = clamp(color.a + clamp( pow(clamp((UV.x - 1. + margins.z) / margins.z, 0., 1.), slope), 0., 1.), 0. ,1.);
	color.a = clamp(color.a + clamp( pow(clamp((UV.y - 1. + margins.w) / margins.w, 0., 1.), slope), 0., 1.), 0., 1.);


	color.a *= peak_a;
	color.a *= alpha;
	if (invert) color.a = clamp(1. - color.a, 0. ,1.);
	color.a *= modulate.a;
	COLOR = color;

}