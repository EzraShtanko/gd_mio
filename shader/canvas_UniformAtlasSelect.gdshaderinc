
vec4 texture_atlas(sampler2D atlas_map, ivec2 atlas_dimensions, ivec2 sector_dimensions, ivec2 sector_coord, int variant, vec2 _uv) {
	vec2 uv = _uv / vec2(atlas_dimensions) + vec2(1.) / vec2(atlas_dimensions) * vec2(sector_dimensions) * vec2(sector_coord);
	uv += vec2(ivec2(variant % sector_dimensions.x, (variant / sector_dimensions.x) % sector_dimensions.y)) / vec2(atlas_dimensions);
	return texture(atlas_map, uv);
}