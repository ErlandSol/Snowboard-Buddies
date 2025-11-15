shader_type sky;

uniform sampler2D skyTexture;
uniform sampler2D noise;


void sky() {
	vec3 skyColor = texture(skyTexture,SKY_COORDS).rgb;
	vec3 noiseColor = texture(noise,SKY_COORDS+vec2(TIME*0.01,0)).rgb;
	vec3 noiseColor2 = texture(noise,SKY_COORDS+vec2(TIME*-0.01,TIME*-0.01)).rgb;

	skyColor.r = pow(skyColor.r,1.8);
	COLOR = skyColor.rrr + noiseColor * noiseColor2.r;

	// Called for every visible pixel in the sky background, as well as all pixels
	// in the radiance cubemap.
}
