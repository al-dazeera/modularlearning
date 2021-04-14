shader_type canvas_item;

uniform float alpha;
uniform vec3 color;
uniform sampler2D vignette;

void fragment() {
	vec4 final=vec4(color.x,color.y,color.z,alpha);
	vec3 vignette_color = texture(vignette, UV).rgb;
	// Screen texture stores gaussian blurred copies on mipmaps.
	COLOR.rgba = (textureLod(SCREEN_TEXTURE, SCREEN_UV, (1.0 - vignette_color.r) * 4.0).rgba);
	COLOR.rgba *= texture(vignette, UV).rgba+final;
}
