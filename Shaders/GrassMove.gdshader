shader_type spatial;
render_mode cull_disabled;

uniform vec3 color : source_color;
uniform vec3 color2 : source_color;
uniform sampler2D noise;
uniform float noiseScale = 20;
uniform float windStrength = 0.1;
uniform vec3 windDirection = vec3(0.02, 0.01, 0.02);
uniform vec3 player_pos = vec3(0.0);
uniform int interact_power = 4;
uniform float radius = 4.0;
varying vec3 worldPos;

void vertex() {
	//Aplly movement and noise into model vertex grass
	worldPos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float noiseValue = texture(noise, worldPos.xz / noiseScale).r;
	vec3 displacement = noiseValue * windStrength * windDirection;
	VERTEX += displacement * (1.0 - UV.y) * sin(noiseValue + TIME);
	
	//Make the player interact with the grass based on the position
	vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 direction = world_vert - player_pos;
	direction.y = 0.0;
	direction = normalize(direction);
	float interact_power_pot = float(interact_power) * 0.00001;
	float dist = distance(player_pos, world_vert);
	float power = smoothstep(radius, 0.0, dist);
	//direction = (inverse(MODEL_MATRIX) * vec4(direction, 1.0)).xyz;
	direction = (vec4(direction, 1.0) * MODEL_MATRIX).xyz;
	VERTEX += direction * power * interact_power_pot * (1.0 - UV.y);
}

void fragment() {
	//Gives grass a mixed color and noise aspect. The normal off the non-seeing faces are fixed
    vec3 noiseLevel = texture(noise, worldPos.xz / noiseScale).rgb;
    ALBEDO = mix(color, color2, 1.0 - UV.y) * mix(color, color2, noiseLevel.r);
    if (!FRONT_FACING) {
        NORMAL = -NORMAL;
    }
}
