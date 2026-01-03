

float random(float added_seed) 							{ return fract(sin(dot(vec2(TIME + added_seed), vec2(12.9898, 4.1414))) * 43758.5453); }
float random_range(vec2 _range, float added_seed) 		{ return random(added_seed) * (_range.y - _range.x) + _range.x;}

mat4 random_rotation(float added_seed, vec2 spread) {
	float _x = (random_range(vec2(-spread.x, spread.x), 0.0 + added_seed)) * PI;
	float _y = (random_range(vec2(-spread.y, spread.y), 1.0 + added_seed)) * PI;

	vec3 horizontal_base = vec3(cos(_x), 0.0, sin(_x));
	vec3 vertical_base = vec3(cos(_y + PI / 2.0), sin(_y + PI / 2.0), 0.0);
	vec3 z_axis = normalize(cross(horizontal_base, vertical_base));
	vec3 y_axis = normalize(cross(horizontal_base, z_axis));
	vec3 x_axis = normalize(cross(y_axis, z_axis));

	mat4 result = mat4(1.0);
	result[0].xyz = x_axis;
	result[1].xyz = y_axis;
	result[2].xyz = z_axis;
	result[3].xyz = vec3(0.0);

	return result;
}

mat4 euler_rotation(vec3 v) {
	mat4 r_x = mat4(1.0);
	r_x[0].xyz = vec3(1.0, 			0.0, 			0.0);
	r_x[1].xyz = vec3(0.0, 			cos(v.x), 		-sin(v.x));
	r_x[2].xyz = vec3(0.0, 			sin(v.x), 		cos(v.x));

	mat4 r_y = mat4(1.0);
	r_y[0].xyz = vec3(cos(v.y), 	0.0, 			sin(v.y));
	r_y[1].xyz = vec3(0.0,			1.0,			0.0);
	r_y[2].xyz = vec3(-sin(v.y),	0.0,			cos(v.y));

	mat4 r_z = mat4(1.0);
	r_z[0].xyz = vec3(cos(v.z),		-sin(v.z),		0.0);
	r_z[1].xyz = vec3(sin(v.z),		cos(v.z),		0.0);
	r_z[3].xyz = vec3(0.0,			0.0,			1.0);

	return r_z * r_y * r_x;
}

mat4 axis_angle(float angle, vec3 axis) {

	mat4 R = mat4(1.0);

	R[0].xyz = vec3(
		cos(angle) + pow(axis.x, 2.0) * (1.0 - cos(angle)),
		axis.x * axis.y * (1.0 - cos(angle)) - axis.z * sin(angle),
		axis.x * axis.z * (1.0 - cos(angle)) + axis.y * sin(angle)
	);
	R[1].xyz = vec3(
		axis.y * axis.x * (1.0 - cos(angle)) + axis.z * sin(angle),
		cos(angle) + pow(axis.y, 2.0) * (1.0 - cos(angle)),
		axis.y * axis.z * (1.0 - cos(angle)) - axis.x * sin(angle)
	);
	R[2].xyz = vec3(
		axis.z * axis.x * (1.0 - cos(angle)) - axis.y * sin(angle),
		axis.z * axis.y * (1.0 - cos(angle)) + axis.x * sin(angle),
		cos(angle) + pow(axis.z, 2.0) * (1.0 - cos(angle))
	);

	return R;
}

mat4 random_scale(vec2 min_max, float added_seed) {

	float _scale = random_range(min_max, added_seed + 16.15);

	mat4 scale_transform = mat4(1.0);
	scale_transform[0].xyz = vec3(_scale, 0.0,  0.0);
	scale_transform[1].xyz = vec3(0.0, _scale,  0.0);
	scale_transform[2].xyz = vec3(0.0,    0.0,  _scale);

	return scale_transform;
}

vec3 rotated_euler(vec3 target, vec3 rotation) {
	vec3 result = (vec4(target, 1.0) * euler_rotation(rotation)).xyz;
	return result;
}

vec3 rotated_axis(vec3 target, float angle, vec3 axis) {
	vec3 result = (axis_angle(angle, axis) * vec4(target, 1.0)).xyz;
	return result;
}