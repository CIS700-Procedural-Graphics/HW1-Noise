varying vec2 vUv;
varying vec3 color;


// From http://stackoverflow.com/questions/4200224/random-noise-functions-for-glsl
float noise_gen1(float x, float y, float z) {
	return fract(sin(dot(vec3(x, y, z) ,vec3(12.9898,78.233, 1.0))) * 43758.5453);
}

float noise_gen2(float x, float y) {
	//TODO
	return x;
}

float M_PI = 3.14159265359;

// From the noise lecture (slide 26)
float cosine_interp(float a, float b, float t) {
	float cos_t = (1.0 - cos(t * M_PI)) * 0.5;
	return a * (1.0 - cos_t) + b * cos_t;
}

float interp_noise(float x, float y, float z) { 
	float x0 = floor(x),
		y0 = floor(y),
		z0 = floor(z),
	 	x1 = ceil(x),
	 	y1 = ceil(y),
	 	z1 = ceil(z);

	float p1 = noise_gen1(x0, y0, z0),
		p2 = noise_gen1(x1, y0, z0),
		p3 = noise_gen1(x0, y1, z0),
		p4 = noise_gen1(x0, y0, z1),
		p5 = noise_gen1(x0, y1, z1),
		p6 = noise_gen1(x1, y1, z0),
		p7 = noise_gen1(x1, y0, z1),
		p8 = noise_gen1(x1, y1, z1);

	float dx = (x - x0) / (x1 - x0),
		dy = (y - y0) / (y1 - y0),
		dz = (z - z0) / (z1 - z0);

	// Interpolate along x
	float a1 = cosine_interp(p1, p2, dx),
		a2 = cosine_interp(p4, p7, dx), 
		a3 = cosine_interp(p3, p6, dx),
		a4 = cosine_interp(p5, p8, dx);

	// Interpolate along y
	float b1 = cosine_interp(a1, a3, dy),
		b2 = cosine_interp(a2, a4, dy);

	// Interpolate along z
	float c = cosine_interp(b1, b2, dz);

	return c; 
}



float multi_octave_noise () {
	// TODO
	return 1.0;
}

void main() {
    vUv = uv;
    vec3 noise_pos = position;

    noise_pos *= interp_noise(position.x, position.y, position.z);//vec3(normal.x, normal.y, normal.z);

    gl_Position = projectionMatrix * modelViewMatrix * vec4( noise_pos, 1.0 );
    color = vec3(normal.x, normal.y, normal.z);
}